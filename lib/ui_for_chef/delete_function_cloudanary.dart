import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> deleteFromCloudinary(String publicId) async {
  String cloudName = 'dsyujcmxf'; // Replace with your Cloudinary cloud name
  String apiKey = '281812455221178'; // Replace with your Cloudinary API key
  String apiSecret = 'In9OHoR5b3o4CKrHcMmJkAFzmTU'; // Replace with your Cloudinary API secret

  var uri = Uri.parse("https://api.cloudinary.com/v1_1/dsyujcmxf/image/destroy");

  // Create the request body
  var body = {
    'public_id': publicId,  // The public ID of the image you want to delete
    'api_key': apiKey,  // Your Cloudinary API key
    'api_secret': apiSecret,  // Your Cloudinary API secret
  };

  try {
    // Send a POST request to delete the image
    var response = await http.post(uri, body: body);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      // Check if the response indicates a successful deletion
      if (jsonResponse['result'] == 'ok') {
        print('Image deleted successfully');
        return true;
      } else {
        print('Failed to delete image: ${jsonResponse['error']['message']}');
        return false;
      }
    } else {
      print('Failed to delete image. Status code: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error deleting image: $e');
    return false;
  }
}
