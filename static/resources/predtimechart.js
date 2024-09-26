import App from 'https://cdn.jsdelivr.net/gh/reichlab/predtimechart@2.0.10/dist/predtimechart.bundle.js';
document.predtimechart = App;  // for debugging

function replace_chars(the_string) {
    // replace all non-alphanumeric characters, except dashes and underscores, with a dash
    return the_string.replace(/[^a-zA-Z0-9-_]/g, '-');
}

const root = "https://raw.githubusercontent.com/hubverse-org/hub-dashboard-predtimechart/refs/heads/main/demo/";

// a simple fetchData() that hard-codes truth and forecast data for two reference_dates
function _fetchData(isForecast, targetKey, taskIDs, referenceDate) {
    // ex taskIDs: {"scenario_id": "A-2022-05-09", "location": "US"} . NB: key order not sorted
    console.info("_fetchData(): entered.", isForecast, `"${targetKey}"`, taskIDs, `"${referenceDate}"`);

    const targetKeyStr = replace_chars(targetKey);

    // get .json file name: 1) get taskIDs values ordered by sorted keys, 2) clean up ala `json_file_name()`
    const taskIDsValsSorted = Object.keys(taskIDs).sort().map(key => taskIDs[key]);
    const taskIDsValsStr = replace_chars(taskIDsValsSorted.join(' '));

    let target_path;
    const file_name = `${targetKeyStr}_${taskIDsValsStr}_${referenceDate}.json`;
    if (isForecast) {
        // target_path = `./static/data/forecasts/${file_name}`;
        target_path = `${root}/${file_name}`;
    } else {
        // target_path = `./static/data/truth/${file_name}`;
        console.warn("_fetchData(): target/truth data is currently unavailable");
        return new Promise((resolve) => {
            console.info("_fetchData(): resolving");
            resolve({
                json: () => Promise.resolve({})
            });
        });
    }
    return fetch(target_path);  // Promise
}


// load options and then initialize the component
fetch(`${root}/predtimechart-options.json`)
    .then(response => response.json())
    .then((data) => {
        console.info("fetch(): done. calling App.initialize().", data);

        // componentDiv, _fetchData, isIndicateRedraw, options, _calcUemForecasts:
        App.initialize('forecastViz_row', _fetchData, false, data, null);
    })
    .then(function() {
        // ZNK 2024-09-16: update for bootstrap 5
        console.log(document.getElementById("forecastVis_options"));
        document.getElementById("forecastViz_options").classList.add("g-col-3");
        console.log(document.getElementById("forecastVis_viz"));
        document.getElementById("forecastViz_viz").classList.add("g-col-9");
    });

window.addEventListener('DOMContentLoaded', function() {
  document.getElementById("forecastViz_options").classList.add("g-col-3");
  document.getElementById("forecastViz_viz").classList.add("g-col-9");
});



