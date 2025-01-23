import requests
import sys
import logging
import os

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Replace with your bot token and channel ID
BOT_TOKEN = ''
CHANNEL_ID = ''  # Use the channel username or ID

# Telegram API URL
url = f'https://api.telegram.org/bot{BOT_TOKEN}/sendPhoto'

def send_photo(photo_path, caption):
    """Send a photo to the Telegram channel."""
    try:
        # Check if the file exists
        if not os.path.exists(photo_path):
            logging.error(f"File not found: {photo_path}")
            return False

        # Check if the file is readable
        if not os.access(photo_path, os.R_OK):
            logging.error(f"File is not readable: {photo_path}")
            return False

        # Send the photo to Telegram
        with open(photo_path, 'rb') as photo:
            files = {'photo': photo}
            data = {'chat_id': CHANNEL_ID, 'caption': caption}
            response = requests.post(url, files=files, data=data)
            response.raise_for_status()  # Raise an error for bad status codes
            logging.info(f"Photo sent successfully: {photo_path}")
            return True
    except Exception as e:
        logging.error(f"Failed to send photo {photo_path}: {e}")
        return False

if __name__ == "__main__":
    # Read the image file path from stdin
    image_path = sys.stdin.readline().strip()
    if not image_path:
        logging.error("No image path provided.")
        sys.exit(1)

    # Send the image to Telegram
    caption = f"New image captured: {os.path.basename(image_path)}"
    if send_photo(image_path, caption):
        logging.info("Image sent successfully!")
    else:
        logging.error("Failed to send image.")
