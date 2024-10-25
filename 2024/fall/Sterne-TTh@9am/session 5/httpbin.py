import requests
import uuid

# Step 1: Successfully log in using basic auth
def login_basic_auth():
    print("\n--- Step 1: Basic Auth Login ---")
    url = "https://httpbin.org/basic-auth/user/pass"
    response = requests.get(url, auth=('user', 'pass'))
    print("Request URL:", response.request.url)
    print("Request Headers:", response.request.headers)
    print("Response Status Code:", response.status_code)
    print("Response JSON:", response.json())
    print("Response Text:", response.text)

# Step 2: Download an image
def download_image():
    print("\n--- Step 2: Downloading an Image ---")
    image_url = "https://httpbin.org/image/png"
    response = requests.get(image_url)
    print("Request URL:", response.request.url)
    print("Request Headers:", response.request.headers)
    print("Response Status Code:", response.status_code)
    if response.status_code == 200:
        with open("downloaded_image.png", "wb") as file:
            file.write(response.content)
        print("Image downloaded successfully as 'downloaded_image.png'.")
    else:
        print("Failed to download image.")

# Step 3: Generate a UUID4
def generate_uuid():
    print("\n--- Step 3: Generating UUID4 ---")
    generated_uuid = str(uuid.uuid4())
    print("Generated UUID4:", generated_uuid)
    return generated_uuid

# Step 4: Return a simple JSON response
def return_json_response():
    print("\n--- Step 4: Returning a Simple JSON Response ---")
    url = "https://httpbin.org/anything"
    data = {
        "message": "Hello, this is a simple JSON response!",
        "uuid": generate_uuid()
    }
    response = requests.post(url, json=data)
    print("Request URL:", response.request.url)
    print("Request Headers:", response.request.headers)
    print("Request JSON Payload:", data)
    print("Response Status Code:", response.status_code)
    print("Response JSON:", response.json())

# Main function to run all steps
def main():
    login_basic_auth()
    download_image()
    return_json_response()

if __name__ == "__main__":
    main()