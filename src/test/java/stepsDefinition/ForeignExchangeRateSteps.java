package stepsDefinition;

import io.cucumber.java.Before;
import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import org.junit.Assert;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Logger;


public class ForeignExchangeRateSteps {
    private final String BASE_URI=  "https://api.ratesapi.io/api";
    private Response response;
    private static Logger log = Logger.getLogger(ForeignExchangeRateSteps.class.getName());
    private LocalDate date= LocalDate.now();

    @Before
    public void setBaseUri(){
        RestAssured.baseURI=BASE_URI;
        log.info("Setting Base URL");
    }

    @Given ("User opens ratesapi page")
    public void userOpensRatesApiSite(){
        int code = RestAssured.when().get("https://ratesapi.io/").statusCode();
        log.info("Checking ratesapi is operative");
        Assert.assertEquals(200, code);
    }

    @When("User requests {string}")
    public void userMakesRequest(String path){
        if(path.contains("$current_date")){
            path=date.minusDays(1).toString();
        }
        response = RestAssured.when().get(path).then().extract().response();
        log.info("Sending request to " + BASE_URI+path);
}

    @Then("Request sent. Status code is {int}")
    public void checkStatusCode(int statusCode){
        log.info("Checking a response status code");
        Assert.assertEquals(statusCode, response.getStatusCode());
}

    @And("Response contains more than 20 rates against {string}")
    public void checkAllRates(String base){
        String responseBase = response.jsonPath().get("base");
        log.info("Checking base currency is " + responseBase);
        Assert.assertEquals(base, responseBase);
        HashMap rates = response.jsonPath().get("rates");
        log.info("Checking total amount of rates more than 20");
        Assert.assertTrue("Total count of rates is less then expected. Actual count is: " + rates.size(),rates.size()>20);

}

    @And("Response contains current date")
    public void checkingCurrentDate(){
        log.info("Checking the response contains current or prior date");
        String responseDate = response.jsonPath().get("date");
        Assert.assertTrue("Response date is different as expected. Expected: "+responseDate+" Actual date: "+date,
                responseDate.contains(date.toString()) || responseDate.contains(date.minusDays(1).toString()));
    }

    @When ("User requests {string} using the following {string} as {string}")
    public void userMakesRequestWithSymbols(String path, String value, String param){
        response = RestAssured
                .given().param(param, value)
                .when().get(path)
                .then().extract().response();
        log.info("Sending request to " + BASE_URI+path+" with params: " + param + " = " + value);
    }

    @And ("Response contains value listed in {string}")
    public void checkResponseParams(String value){
        List<String> list = new ArrayList<>();
        if(value.contains(",")){
            String[] values = value.split(",");
             list=Arrays.asList(values);
        }else list.add(value);
        log.info("Checking the response contains param value");
        String rate = response.asString();
        for (String temp:list) {
            Assert.assertTrue("Rate is different as expected.Expected: "+ rate+" Actual rate:"+temp,rate.contains(temp))  ;
        }
    }

    @When ("User requests {string} using the following {string} and {string} params")
    public void userMakesRequestWithBaseAndSymbols(String path,String base, String symbols){
        response = RestAssured.given().param("base", base)
                .param("symbols", symbols)
                .when().get(path)
                .then().extract().response();
        log.info("Sending request to " + BASE_URI+path+" with params: base = " + base + " symbols = " + symbols);
    }

    @And ("Response contains {string}")
    public void checkingErrorMessage(String message){
        log.info("Checking the response contains error message " + message);
        String rate = response.asString();
        Assert.assertTrue("Actual message is different as expected. Expected: "+message+" Actual: "+rate,rate.contains(message));
    }
    @And ("Response contains date same as listed in {string}")
    public void checkDateFromResponse(String pastDate){
        if(pastDate.contains("$current_date")){
            pastDate=" "+date.minusDays(1).toString();
        }
        log.info("Checking the response contains past date");
        String responseDate = response.jsonPath().get("date");
        Assert.assertEquals(pastDate.substring(1), responseDate);
    }

}
