import com.github.javafaker.CreditCardType;
import com.github.javafaker.Faker;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DataGenerator {

  public static String[] getRandomAddress() {
    Faker faker = new Faker();
    String number = faker.address().buildingNumber();
    String streetName = faker.address().streetName();
    String city = faker.address().city();
    String zipCode = faker.address().zipCode();
    String countryCode = faker.address().countryCode();
    return new String[] {number, streetName, city, zipCode, countryCode};
  }

  public static String getRandomCompany() {
    Faker faker = new Faker();
    String company = faker.company().name();
    return company;
  }

  public static String getRandomCreditCardNumber() {
    Faker faker = new Faker();
    String creditCard = faker.finance().creditCard(CreditCardType.valueOf("MASTERCARD"));
    return creditCard;
  }

  public static String getRandomDescription() {
    Faker faker = new Faker();
    String description = faker.princessBride().quote();
    return description;
  }

  public static String getRandomDOB(int minAge, int maxAge) {
    Faker faker = new Faker();
    Date birthday = faker.date().birthday(minAge, maxAge);
    SimpleDateFormat ymdFormat = new SimpleDateFormat("yyyy-MM-dd");
    String ymd = ymdFormat.format(birthday);
    return ymd;
  }

  public static String getRandomEmail() {
    Faker faker = new Faker();
    String email =
        faker.name().firstName().toLowerCase() + faker.random().nextInt(0, 100) + "@test.com";
    return email;
  }

  public static String getRandomGender() {
    Faker faker = new Faker();
    String gender = faker.dog().gender();
    return gender;
  }

  public static String[] getRandomName() {
    Faker faker = new Faker();
    String firstName = faker.name().firstName();
    String lastName = faker.name().lastName();
    return new String[] {firstName, lastName};
  }

  public static String getRandomUrl() {
    Faker faker = new Faker();
    String randomUrl = faker.company().url();
    return randomUrl;
  }
}
