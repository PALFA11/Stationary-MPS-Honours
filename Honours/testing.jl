using Random # fix rng seed
# Pkg.status()
# import Pkg
# Pkg.activate("C:/Users/Lukas Robinson/.julia/environments/Honours");
# Pkg.instantiate();

using MPSTime
using Plots

# plotlyjs()

rng = Xoshiro(1); # define trendy sine function

function trendy_sine(T::Integer, n_inst::Integer, noise_std::Real, rng)
    X = Matrix{Float64}(undef, n_inst, T)
    ts = 1:T
    for series in eachrow(X)
        phase = 2 * pi * rand(rng)
        @. series = sin(pi/10 * ts + phase) + 3 * ts / T + noise_std * randn(rng)
    end
    return X
end;


ntimepoints = 100;
ntrain_instances = 100;
ntest_instances = 50;

X_train = vcat(
    trendy_sine(ntimepoints, ntrain_instances ÷ 2, 0.1, rng),
    trendy_sine(ntimepoints, ntrain_instances ÷ 2, 0.9, rng)
);

y_train = vcat(
    fill(1, ntrain_instances ÷ 2),
    fill(2, ntrain_instances ÷ 2)
);

X_test = vcat(
    trendy_sine(ntimepoints, ntest_instances ÷ 2, 0.1, rng),
    trendy_sine(ntimepoints, ntest_instances ÷ 2, 0.9, rng)
);

y_test = vcat(
    fill(1, ntest_instances ÷ 2),
    fill(2, ntest_instances ÷ 2)
);



# println(rng)
# opts = MPSOptions()
# println(opts)

# mps, info, test_states = fitMPS(X_train, y_train, X_test, y_test, opts);
# get_training_summary(mps, test_states; print_stats=true)

# # Plotting Training Data
# plot(title="Training Data", xlabel="Time", ylabel="Value")
# for (i, series) in enumerate(eachrow(X_train))
#     plot!(1:ntimepoints, series, color=(y_train[i] == 1 ? :blue : :red), alpha=0.3, label="" )
# end

# # Display Training Plot
# display(current())

# # Plotting Testing Data
# plot(title="Testing Data", xlabel="Time", ylabel="Value")
# for (i, series) in enumerate(eachrow(X_test))
#     plot!(1:ntimepoints, series, color=(y_test[i] == 1 ? :blue : :red), alpha=0.3, label="")
# end

# # Display Testing Plot
# display(current())

# # Plotting Training Data
# plt1 = plot(title="Training Data", xlabel="Time", ylabel="Value")
# for (i, series) in enumerate(eachrow(X_train))
#     plot!(plt1, 1:ntimepoints, series, color=(y_train[i] == 1 ? :blue : :red), alpha=0.3, label="" )
# end

# # Display Training Plot
# plt1

# # Plotting Testing Data
# plt2 = plot(title="Testing Data", xlabel="Time", ylabel="Value")
# for (i, series) in enumerate(eachrow(X_test))
#     plot!(plt2, 1:ntimepoints, series, color=(y_test[i] == 1 ? :blue : :red), alpha=0.3, label="")
# end

# # Display Testing Plot
# plt2

# # Plotting function
# function plot_data1(X, y, title_str)
#     plt = plot()
#     plt = plot(title=title_str, xlabel="Time", ylabel="Value", legend=false)  # Clear any existing plots
#     for (series, label) in zip(eachrow(X), y)
#         plot!(plt, 1:ntimepoints, series, color=(label == 1 ? :blue : :red), alpha=0.5)
#     end
#     return plt
# end

# # Plot and save figures

# # # Display plots
# # display(train_plot)
# # display(test_plot)

# # Save plots
# train_plot = plot_data1(X_train, y_train, "Training Data")
# savefig(train_plot, "training_data_plot.png")


# Plotting function
function plot_data(X, y, title_str)
    plt = plot(title=title_str, xlabel="Time", ylabel="Value", legend=false)  # Clear any existing plots

    # Plot red series (label == 2) first
    for (series, label) in zip(eachrow(X), y)
        if label == 2
            plot!(plt, 1:ntimepoints, series, color=:yellow, alpha=0.5)
        end
    end

    # Plot blue series (label == 1) on top
    for (series, label) in zip(eachrow(X), y)
        if label == 1
            plot!(plt, 1:ntimepoints, series, color=:green, alpha=0.5)
        end
    end

    return plt
end

test_plot = plot_data(X_test, y_test, "Testing Data")
savefig(test_plot, "testing_data_plot.png")