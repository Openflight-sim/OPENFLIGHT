

# code below modified from https://github.com/AlexS12/FlightMechanics.jl/blob/master/src/atmosphere.jl

const G0 = GRAVITY_ACCEL

"""
    atmosphere_isa(height)

Calculate temperature, pressure, density and sound velocity for the
given geopotential height according to International Standard Atmosphere 1976.

# References

- [1] U.S. Standard Atmosphere, 1976, U.S. Government Printing Office,
        Washington, D.C., 1976

From: https://en.wikipedia.org/wiki/U.S._Standard_Atmosphere

| Layer | h (m) | p (Pa)  | T (K)  | ``α`` (K/m) |
|-------|-------|---------|--------|-------------|
| 0     | 0     | 101325  | 288.15 | -0.0065     |
| 1     | 11000 | 22632.1 | 216.65 | 0           |
| 2     | 20000 | 5474.89 | 216.65 | 0.001       |
| 3     | 32000 | 868.019 | 228.65 | 0.0028      |
| 4     | 47000 | 110.906 | 270.65 | 0           |
| 5     | 51000 | 66.9389 | 270.65 | -0.0028     |
| 6     | 71000 | 3.95642 | 214.65 | -0.002      |
"""
function atmosphere_isa(height)

    if  height < 11000  # Troposphere
        temperature_lapse_rate = -0.0065  # K/m
        T0 = 288.15      # K
        p0 = 101325.0    # Pa

        T = T0 + temperature_lapse_rate * height
        p = p0 * (T0 / T) ^ (G0 / (R_AIR * temperature_lapse_rate))

    elseif 11000 <= height < 20000  # Tropopause
        T = 216.65    # K
        p0 = 22632.1  # Pa
        h0 = 11000    # m

        p = p0 * exp(-G0 * (height - h0) / (R_AIR * T))

    elseif 20000 <= height < 32000  # Stratosphere 1
        temperature_lapse_rate = 0.001    # K/m
        T0 = 216.65      # K
        p0 = 5474.89     # Pa
        h0 = 20000       # m

        T = T0 + temperature_lapse_rate * (height - h0)
        p = p0 * (T0 / T) ^ (G0 / (R_AIR * temperature_lapse_rate))

    elseif 32000 <= height < 47000  # Stratosphere 2
        temperature_lapse_rate = 0.0028   # K/m
        T0 = 228.65      # K
        p0 = 868.019     # Pa
        h0 = 32000       # m

        T = T0 + temperature_lapse_rate * (height - h0)
        p = p0 * (T0 / T) ^ (G0 / (R_AIR * temperature_lapse_rate))

    elseif 47000 <= height < 51000  # Stratopause
        T = 270.65    # K
        p0 = 110.906  # Pa
        h0 = 47000    # m
        h0 = 47000    # m

        p = p0 * exp(-G0 * (height - h0) / (R_AIR * T))

    elseif 51000 <= height < 71000  # Mesosphere 1
        temperature_lapse_rate = -0.0028  # K/m
        T0 = 270.65      # K
        p0 = 66.9389     # Pa
        h0 = 51000       # m

        T = T0 + temperature_lapse_rate * (height - h0)
        p = p0 * (T0 / T) ^ (G0 / (R_AIR * temperature_lapse_rate))

    elseif 71000 <= height <= 84500  # Mesosphere 2
        temperature_lapse_rate = -0.002   # K/m
        T0 = 214.65      # K
        p0 = 3.95642     # Pa
        h0 = 71000       # m

        T = T0 + temperature_lapse_rate * (height - h0)
        p = p0 * (T0 / T) ^ (G0 / (R_AIR * temperature_lapse_rate))

    else
        throw(DomainError(height, "height must be less than 84500 m"))
    end

    rho = p / (R_AIR * T)
    a   = sqrt(GAMMA_AIR * R_AIR * T)
    sigma = rho / 1.225

    return [T, p, rho, a, sigma]
end