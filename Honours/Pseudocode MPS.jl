using Random # fix rng seed
# using Pkg
# import Pkg
# Pkg.activate("C:/Users/Lukas Robinson/.julia/environments/Honours");
# Pkg.instantiate();
using PrettyTables
using MPSTime
using Plots

rng = Xoshiro(1); # define trendy sine function

function trendy_sine(T::Integer, n_inst::Integer, sigma::Real, rng)
    X = Matrix{Float64}(undef, n_inst, T)
    ts = collect(1:T)
    for i in 1:n_inst
        phase = 2 * pi * rand(rng)
        X[i, :] = 0.5 .* sin.(pi/10 .* ts .+ phase) .+ 0.5 .+ (sigma .* randn(rng, T))
    end
    return X
end;



# time_series = trendy_sine(ntimepoints, ntrain_instances, 0, rng)
# println(size(time_series))
# encoded_series = [ [cos(pi/2*x), sin(pi/2 * x)] for x in time_series] 

# println(size(encoded_series))
# plt = plot(xlabel="Time", ylabel="Value", legend=false)  # Clear any existing plots

# for i in 1:ntrain_instances
#     plot!(plt, 1:ntimepoints, time_series[i, :], color=:red, alpha=0.5)
# end

# display(plt)
# readline()

# dataset size
ntimepoints = 20
ntrain_instances = 1000
ntest_instances = 500

# generate the train and test datasets
X_train = trendy_sine(ntimepoints, ntrain_instances, 0.3, rng);
X_test = trendy_sine(ntimepoints, ntest_instances, 0.3, rng);

# hyper parameters and training
opts = MPSOptions(d=2, chi_max=50, sigmoid_transform=false);
mps, info, test_states= fitMPS(X_train, opts);

class = 0
instance_idx = 10  # Example test instance
impute_sites = [ntimepoints]  # The next point to predict (out of the known range)
method = :ITS  # Trajectory sampling method for uncertainty estimation

imp = init_imputation_problem(mps, X_test);

imputed_ts, pred_err, target_ts, stats, plots = MPS_impute(
    imp,
    class, 
    instance_idx, 
    impute_sites, 
    method; 
    NN_baseline=true, 
    plot_fits=true, 
    num_trajectories=10, 
    rejection_threshold=2.5
)

pretty_table(stats[1]; header=["Metric", "Value"], header_crayon= crayon"yellow bold", tf = tf_unicode_rounded);

plt = plot(plots...)

display(plt)
readline()