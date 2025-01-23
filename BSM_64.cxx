/* 

    Monte Carlo Hackathon created by Hafsa Demnati and Patrick Demichel @ Viridien 2024
    The code compute a Call Option with a Monte Carlo method and compare the result with the analytical equation of Black-Scholes Merton : more details in the documentation

    Compilation : g++ -O BSM.cxx -o BSM

    Exemple of run: ./BSM #simulations #runs

./BSM 100 1000000
Global initial seed: 21852687      argv[1]= 100     argv[2]= 1000000
 value= 5.136359 in 10.191287 seconds

./BSM 100 1000000Probablement dans un mail du type confirmation d'inscription
Global initial seed: 4208275479      argv[1]= 100     argv[2]= 1000000
 value= 5.138515 in 10.223189 seconds
 
   We want the performance and value for largest # of simulations as it will define a more precise pricing
   If you run multiple runs you will see that the value fluctuate as expected
   The large number of runs will generate a more precise value then you will converge but it require a large computation

   give values for ./BSM 100000 1000000        
               for ./BSM 1000000 1000000
               for ./BSM 10000000 1000000
               for ./BSM 100000000 1000000
  
   We give points for best performance for each group of runs 

   You need to tune and parallelize the code to run for large # of simulations

*/

#include <iostream>
#include <random>
#include <vector>
#include <limits>
#include <algorithm>
#include <iomanip>   // For setting precision
#include <cmath> // Pour std::erf et std::sqrt

#define ui64 u_int64_t
#define f32 float
#define f64 double
// include added for the optimization
#include <omp.h>
#include <armpl.h>
#include <amath.h>
#include <arm_neon.h>
#include <arm_sve.h>

#include <sys/time.h>
double dml_micros()
{
        static struct timezone tz;
        static struct timeval  tv;
        gettimeofday(&tv,&tz);
        return((tv.tv_sec*1000000.0)+tv.tv_usec);
}


// class SVERandomGenerator {
// private:


// public:

//     svuint64_t state;
//     svuint64_t inc;

//     SVERandomGenerator(uint64_t seed) {
//         svuint64_t state = svdup_n_u64(seed);
//         svuint64_t inc = svdup_n_u64((seed << 1) | 1);
//     }

//     svfloat64_t generate(svbool_t pg) {
//         svuint64_t oldstate = state;
//         state = svadd_u64_z(pg, svmul_u64_z(pg, oldstate, svdup_n_u64(6364136223846793005ULL)), inc);
//         svuint64_t xorshifted = svlsr_n_u64_z(pg, svxor_u64_z(pg, svlsr_n_u64_z(pg, oldstate, 18), oldstate), 27);
//         svuint64_t rot = svlsr_n_u64_z(pg, oldstate, 59);
//         svuint64_t result = svadd_u64_z(pg, svlsr_u64_z(pg, xorshifted, rot), oldstate);
//         return svscale_f64_z(pg, svcvt_f64_u64_z(pg, result), svdup_n_f64(5.42101086242752217E-20));
//     }
// };

// Vectorized Box-Muller transform

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <num_simulations> <num_runs>" << std::endl;
        return 1;
    }

    ui64 num_simulations = std::stoull(argv[1]);
    ui64 num_runs        = std::stoull(argv[2]);

    // Input parameters
    ui64 S0      = 100;                   // Initial stock price
    ui64 K       = 110;                   // Strike price
    double T     = 1.0;                   // Time to maturity (1 year)
    double r     = 0.06;                  // Risk-free interest rate
    double sigma = 0.2;                   // Volatility
    double q     = 0.03;                  // Dividend yield

    const double lambda= sigma * sqrt(T);
    const double exp_lambda0 = S0* exp((r - q - 0.5 * sigma * sigma) * T);
    const double lnZcompare = log(K/exp_lambda0)/lambda;
    const double exprt = exp(-r * T)/num_simulations;

    const double a=exprt*exp_lambda0;
    const double b=-exprt*K; 

    // Generate a random seed at the start of the program using random_device
    std::random_device rd;
    unsigned long long global_seed = rd();  // This will be the global seed

    std::cout << "Global initial seed: " << global_seed << "      argv[1]= " << argv[1] << "     argv[2]= " << argv[2] <<  std::endl;

    double sum=0.0;
    double t1=dml_micros();
    ui64 run=0;
    
    #pragma omp parallel for reduction(+:sum)

    for (run = 0; run < num_runs; ++run) {
        thread_local static std::mt19937 generator(std::random_device{}());
        thread_local static std::normal_distribution<f64> distribution(0.0, 1.0);
        //SVERandomGenerator rng(std::random_device{}());

        svbool_t pg = svptrue_b64();
        svfloat64_t a_vec = svdup_f64(a);
        svfloat64_t b_vec = svdup_f64(b);
        svfloat64_t lambda_vec = svdup_f64(lambda);
        svfloat64_t lnZcompare_vec = svdup_f64(lnZcompare);
        svfloat64_t sum_vec = svdup_f64(0.0);
        
        for (ui64 i = 0; i < num_simulations; i += svcntd()) {
            // Generate random numbers
            // svfloat64_t u1 = svdup_f64(0.0);
            // svfloat64_t u2 = svdup_f64(0.0);
            svfloat64_t Z_vec = svdup_f64(0.0);
            svbool_t mask = svwhilelt_b64(i, num_simulations);

            // Generate random numbers for each active element
            for (ui64 j = 0; j < svcntw(); ++j) {
                if (svptest_first(svptrue_b64(), mask)) {
                    float random_value = distribution(generator);
                    Z_vec = svdup_n_f64_z(mask, random_value);
                    // u1 = svdup_n_f64_z(mask, generator());
                    // u2 = svdup_n_f64_z(mask, generator());
                    mask = svpnext_b64(pg,mask);
                } else {
                    break;
                }
            }

            // svfloat64_t two_pi = svdup_n_f64(2.0 * M_PI);
            // svfloat64_t sqrt_neg_two_log_u1 = svsqrt_f64_z(pg, svneg_f64_z(pg, svmul_f64_z(pg, svdup_n_f64(2.0), _ZGVsMxv_log(u1,pg))));
            // svfloat64_t two_pi_u2 = svmul_f64_z(pg, two_pi, u2);
            
            // // Transform to normal distribution
            // Z_vec = svmul_f64_z(pg, sqrt_neg_two_log_u1, _ZGVsMxv_sin(two_pi_u2, pg));
            // Perform computations
            svbool_t cmp_mask = svcmpgt(pg, Z_vec, lnZcompare_vec);
            svfloat64_t mul_result = svmul_f64_x(pg, lambda_vec, Z_vec);
            svfloat64_t exp_result = _ZGVsMxv_exp(mul_result,pg);
            svfloat64_t result = svadd_f64_x(pg, svmul_f64_x(pg, a_vec, exp_result), b_vec);
            
            sum_vec = svadd_f64_m(cmp_mask, sum_vec, result);
        }
        // std::cout << "u1 : " << run << num_runs << std::endl;
        // Reduce the sum vector to a scalar
        sum += svaddv(svptrue_b64(), sum_vec);
    }

    double t2=dml_micros();
    std::cout << std::fixed << std::setprecision(6) << " Result= " << sum/num_runs << " in " << (t2-t1)/1000000.0 << " seconds" << std::endl;

    return 0;
}

