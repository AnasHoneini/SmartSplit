# SmartSplit

SmartSplit is a mobile application designed to simplify bill splitting among friends. Users can sign up, create groups, add members, create receipts, and share items among group members. The app also keeps track of the receipt history, total prices, and itemized details for each member.

## Features

- **User Signup**: Register and create an account.
- **Create Groups**: Create a group and add members.
- **Manage Receipts**: Create receipts and link them to groups.
- **Add Items**: Add items to receipts and assign them to multiple group members.
- **Track History**: View the history of receipts and detailed information about the total price and individual contributions.

## Screenshots

[screenshots of the app]

## Prerequisites

### Frontend

1. **Install Flutter and Dart:**
   - Download and install Flutter, which includes the Dart language. Follow the instructions on the [official Flutter website](https://flutter.dev/docs/get-started/install).

2. **Set Up an Emulator:**
   - The best emulator is available through Android Studio. Download and install [Android Studio](https://developer.android.com/studio).
   - Open Android Studio and navigate to `AVD Manager` (Android Virtual Device Manager) to create a new virtual device.
   - Download and set up the "Pixel 6 Pro API 30" emulator.

3. **Visual Studio Code:**
   - Install [Visual Studio Code](https://code.visualstudio.com/).
   - Install the Flutter and Dart extensions for Visual Studio Code.

### Backend

1. **Install Node.js:**
   - Download and install Node.js from the [official Node.js website](https://nodejs.org/).

2. **MongoDB:**
   - Ensure you have access to a MongoDB instance. You can set up a local MongoDB server or use a cloud-based solution like [MongoDB Atlas](https://www.mongodb.com/cloud/atlas).

3. **Set Up Environment Variables:**
   - Create a `.env` file in the backend directory with the following content:
     ```env
     JWT_SECRET=your_jwt_secret
     MONGO_URI=your_mongo_db_uri
     ```

## Installation

### Frontend

1. **Clone the repository:**
   ```bash
   git clone https://github.com/AnasHoneini/SmartSplit.git
   cd SmartSplitFrontend\smartsplit\
   ```
   
2. **Install dependencies:**
   ```bash
    flutter pub get
   ```
   
3. **Run the Emulator:**

   - Open Android Studio, navigate to AVD Manager, and start the "Pixel 6 Pro API 30" emulator.

4. **Run the App:**

- Open Visual Studio Code.
- Navigate to the frontend directory and then to the smartsplit directory.
- Run the application:
  
    ```bash
    flutter run
    ```

### Backend

1. **Navigate to the backend directory:**
    ```bash
    cd SmartSplitBackend
    ```
    
2. **Install dependencies:**
    ```bash
    npm install
    ```
3. Run the Backend:
  - Ensure your MongoDB server is running.  
  - Start the backend server:
    
    ```bash
    nodemon app
    ```

## Usage

### 1. Sign Up:
  - Open the app and sign up with your email and password.

### 2. Create a Group:
  - Navigate to the Groups section and create a new group.  
  - Add members to the group by entering their email addresses.

### 3. Create a Receipt:
  - Go to the Receipts section and create a new receipt.  
  - Link the receipt to the appropriate group.

### 4. Add Items:
  - Add items to the receipt.  
  - Assign items to multiple group members if needed.

### 5. View Receipt History:
  - Navigate to the History section to view past receipts.  
  - See the total price of each receipt and individual contributions of group members.
