public class Test_ContentVersion {
    
    public  void testCreateLargeContentVersion() {
        // Define the size of the Blob you want to create (e.g., 10MB)
        Integer fileSizeInBytes = 10 * 1024 * 1024; // 10MB

        // Generate random binary data of the specified size
        Blob largeBlob = createRandomBlob(fileSizeInBytes);

        // Create a ContentVersion record
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Large File';
        cv.VersionData = largeBlob;
        cv.PathOnClient = 'large_file.txt';
        cv.FirstPublishLocationId = null; // Set the appropriate record Id if needed
        // Set other required fields as needed

        // Insert the ContentVersion record
        Test.startTest();
        insert cv;
        Test.stopTest();

        // Perform assertions or further testing if required
    }

    // Helper method to create a Blob of a specific size with random binary data
    public static Blob createRandomBlob(Integer sizeInBytes) {
        Blob randomBlob = Blob.valueOf('x');

        while (randomBlob.size() < sizeInBytes) {
            randomBlob = Blob.valueOf(randomBlob.toString() + createRandomBinaryChunk());
        }

        return randomBlob;
    }

    // Helper method to generate a chunk of random binary data
    public static Blob createRandomBinaryChunk() {
        Blob chunk = Blob.valueOf('');

        while (chunk.size() < 1000) {
            chunk = Blob.valueOf(chunk + String.fromCharArray(new List<Integer>{
                Crypto.getRandomInteger(),
                Crypto.getRandomInteger(),
                Crypto.getRandomInteger(),
                Crypto.getRandomInteger(),
                Crypto.getRandomInteger(),
                Crypto.getRandomInteger(),
                Crypto.getRandomInteger(),
                Crypto.getRandomInteger()
            }));
        }

        return chunk;
    }
}