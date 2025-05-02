public class AimsIntegrationException extends Exception {
    public String internalMessage;
    public String externalMessage;

    public AimsIntegrationException(String internalMessage, String externalMessage) {
        this.internalMessage = internalMessage;
        this.externalMessage = externalMessage;
    }}