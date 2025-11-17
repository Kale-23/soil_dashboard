#' gen_utils
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd

non_dygraph_numeric_cols <- function() {
  c("water_year", "year", "month", "day", "hour", "minute", "frost_tube_id", "pits_tube_id")
}

col_names_conversions <- function() {
  c(
    # new headers
    "field" = "Thompson Field",
    "canopy" = "Thompson Canopy",

    # old headers
    "kingman" = "Kingman",
    "thompson canopy" = "Thompson Canopy",
    "thompson field" = "Thompson Field",
    "frost_tube_id" = "Frost Tube ID",
    "pits_tube_id" = "Pits Tube ID",
    "site_name" = "Site Name",
    "date" = "Date",
    "water_year" = "Water Year",
    "year" = "Year",
    "month" = "Month",
    "day" = "Day",
    "hour" = "Hour",
    "minute" = "Minute",
    "snow_depth_centimeters" = "Snow Depth (cm)",
    "max_frost_depth_centimeters" = "Max Frost Depth (cm)",
    "thaw_depth_centimeters" = "Thaw Depth (cm)",
    "shallow_frost_depth_centimeters" = "Shallow Frost Depth (cm)",
    "frost_depth_1_centimeters" = "Frost Depth 1 (cm)",
    "incoming_radiation_1" = "Incoming Radiation 1",
    "incoming_radiation_2" = "Incoming Radiation 2",
    "incoming_radiation_3" = "Incoming Radiation 3",
    "outgoing_radiation_1" = "Outgoing Radiation 1",
    "outgoing_radiation_2" = "Outgoing Radiation 2",
    "outgoing_radiation_3" = "Outgoing Radiation 3",
    "tube_tare_weight_pounds" = "Tube Tare Weight (lbs)",
    "tube_and_snow_weight_pounds" = "Tube and Snow Weight (lbs)",
    "grain_size_millimeters" = "Grain Size (mm)",
    "snow_weight_kilograms" = "Snow Weight (kg)",
    "surface_temperature_celcius" = "Surface Temperature (°C)",
    "snow_density_kilograms_meters_cubed" = "Snow Density (kg/m³)",
    "snow_water_equivalent_millimeters" = "Snow Water Equivalent (mm)",
    "albedo" = "Albedo"
  )
}
