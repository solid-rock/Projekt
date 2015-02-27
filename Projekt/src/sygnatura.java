import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import sun.misc.BASE64Encoder;


public class sygnatura 
{
	static String secret_keyy = " ";
	
	static String policy_document = "{\"expiration\": \"2017-11-12T00:00:00Z\",\n" +
			"  \"conditions\": [ \n" +
			"    {\"bucket\": \"kamil-projekt\"}, \n" +
			"    [\"starts-with\", \"$key\", \"\"],\n" +
			"    {\"acl\": \"public-read\"},\n" +
			"    {\"success_action_redirect\": \"localhost:8080/queue.jsp\"},\n" +
			"    [\"starts-with\", \"$Content-Type\", \"\"],\n" +
			"    [\"content-length-range\", 0, 1048576]\n" +
			"  ]\n" +
			"}";

	public static void main(String[] args) throws NoSuchAlgorithmException,
			InvalidKeyException, UnsupportedEncodingException 
	{

		String policy = (new BASE64Encoder())
				.encode(policy_document.getBytes("UTF-8")).replaceAll("\n", "")
				.replaceAll("\r", "");

		Mac hmac = Mac.getInstance("HmacSHA1");
		hmac.init(new SecretKeySpec(secret_keyy.getBytes("UTF-8"),"HmacSHA1"));
		String signature = (new BASE64Encoder()).encode(
				hmac.doFinal(policy.getBytes("UTF-8"))).replaceAll("\n", "");

		System.out.println("Policy: "+policy+"\n");
		System.out.println("Signature: "+signature);

	}
}
