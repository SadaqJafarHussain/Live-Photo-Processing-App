import { useState, useCallback } from "react";
import { v4 as uuidv4 } from 'uuid';
import axios from "axios";
import FaceAutoCapture from "./components/FaceAutoCapture";
import styles from "./styles/index.module.css";
import { Step } from "./types";
import type { CallbackImage } from "@innovatrics/dot-document-auto-capture";
import type { FaceCallback } from "@innovatrics/dot-face-auto-capture";
import { Helmet } from "react-helmet"; // Import Helmet

function App() {
  const [step, setStep] = useState<Step>(Step.FACE_CAPTURE);
  const [photoUrl, setPhotoUrl] = useState<string | undefined>(undefined);
  const [processedPhotoUrl, setProcessedPhotoUrl] = useState<string | undefined>(undefined);
  const [processBas64, setbased64] = useState<string | undefined>(undefined);
  const [isProcessing, setIsProcessing] = useState<boolean>(false);

  const handlePhotoTaken = <T,>(imageData: CallbackImage<T>, content?: Uint8Array) => {
    const imageUrl = URL.createObjectURL(imageData.image);
    setPhotoUrl(imageUrl);
    setProcessedPhotoUrl(undefined);
    setbased64(undefined);
    setIsProcessing(true);
    sendImageToAPI(imageData.image);
  };

  const handleFaceCapturePhotoTaken: FaceCallback = (imageData, content) => {
    handlePhotoTaken(imageData, content);
  };

  const handleError = useCallback((error: Error) => {
    alert(error);
  }, []);

  // Type guard to check if a variable is a Blob
  function isBlob(obj: any): obj is Blob {
    return obj instanceof Blob;
  }

  const handleNextClick = async () => {
    if (processedPhotoUrl) {
      setIsProcessing(true);

      console.log("Sending Image:", processedPhotoUrl); // Debugging output

      try {
        // Fetch the image from the URL (processedPhotoUrl is a Blob URL)
        const response = await fetch(processedPhotoUrl);
        const blob = await response.blob();

        // Generate a unique image ID (UUID, or any other method)
        const imageId = 'image-' + uuidv4(); // Simple example, replace with UUID or any unique ID generation method

        // Create a FormData object to send the image as a file and include the imageId
        const formData = new FormData();
        formData.append('image', blob, 'photo.png'); // Add image to FormData
        formData.append('image_id', imageId); // Add unique imageId to FormData

        // Send the image as a file and the unique ID to the API
        const apiResponse = await axios.post('https://nustsys.info/image.php', formData, {
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        });

        // Check if the response is successful (status 200)
        if (apiResponse.status === 200) {
          console.log("Image uploaded successfully!");
          // After successful upload, redirect the user with imageId as a query parameter
          const flutterWebUrl = `https://s-info.nustsys.info/#/capture?imageId=${imageId}`;
          console.log("Redirecting to:", flutterWebUrl);

          // Wait 1 second before redirecting to make sure upload is finished
          window.location.href = flutterWebUrl;
        } else {
          console.error("Failed to upload the image to the API");
        }
      } catch (error) {
        console.error("Error during image upload:", error);
      } finally {
        setIsProcessing(false); // Hide loading indicator
      }
    }
  };

  const sendImageToAPI = async (imageBlob: Blob) => {
    try {
      const formData = new FormData();
      formData.append("image", imageBlob, "photo.png");

      const response = await axios.post(
        "https://web-production-e1d86.up.railway.app/",
        formData,
        {
          headers: { "Content-Type": "multipart/form-data" },
          responseType: "blob",
        }
      );

      if (response.status !== 200) {
        throw new Error("Invalid response from server");
      }
      setbased64(response.data);
      const processedUrl = URL.createObjectURL(response.data);
      setProcessedPhotoUrl(processedUrl);
      setIsProcessing(false);
    } catch (error: any) {
      console.error("Error processing image:", error.response?.data || error.message);
      alert("فشل معالجة الصورة. يرجى المحاولة مرة أخرى.");
      setIsProcessing(false);
    }
  };

  const renderStep = (currentStep: Step) => {
    switch (currentStep) {
      case Step.FACE_CAPTURE:
        return (
          <>
            <Helmet>
              <title>Students Face Captured</title> {/* Set the dynamic title */}
            </Helmet>

            <FaceAutoCapture
              onPhotoTaken={handleFaceCapturePhotoTaken}
              onError={handleError}
              onNextClick={handleNextClick}
              isProcessing={isProcessing}
              photoUrl={photoUrl} // Pass photoUrl state as a prop
            />

            {photoUrl && !processedPhotoUrl && isProcessing && (
              <div style={{ position: "relative", display: "inline-block" }}>
                <img
                  src={photoUrl}
                  alt="Captured"
                  style={{
                    width: "100%",
                    maxWidth: "400px",
                    filter: isProcessing ? "blur(5px)" : "none",
                    objectFit: "cover",
                  }}
                />
                <div
                  style={{
                    position: "absolute",
                    top: "50%",
                    left: "50%",
                    transform: "translate(-50%, -50%)",
                    background: "rgba(0, 0, 0, 0.5)",
                    padding: "10px 20px",
                    color: "white",
                    fontSize: "18px",
                    borderRadius: "10px",
                    fontFamily: "Cairo, sans-serif",
                  }}
                >
                  🔄 جاري المعالجة...
                </div>
              </div>
            )}

            {processedPhotoUrl && !isProcessing && (
              <div>
                <img
                  src={processedPhotoUrl}
                  alt="Processed Result"
                  style={{ width: "100%", maxWidth: "400px", objectFit: "cover" }}
                />
              </div>
            )}
          </>
        );
      default:
        return null;
    }
  };

  return <div className={styles.app}>{renderStep(step)}</div>;
}

export default App;
