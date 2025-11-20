import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.*;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.ErrorHandler;
import java.io.File;
import java.util.*;

/**
 * ============================================================================
 * PARSER DOM POUR PADCHEST
 * ============================================================================
 * Basé sur les exemples du cours Leçon 4 : SAX et DOM (slides 33-43)
 * 
 * Ce parser calcule :
 * 1. Nombre d'images avec localisation "loc right"
 * 2. Top 10 des labels les plus fréquents
 */
public class PadChestParserDOM {
    
    // ========================================================================
    // PROGRAMME PRINCIPAL
    // ========================================================================
    
    public static void main(String[] args) {
        System.out.println("=".repeat(70));
        System.out.println("PARSER DOM - Analyse du fichier PadChest XML");
        System.out.println("=".repeat(70));
        System.out.println();
        
        try {
            // ================================================================
            // ÉTAPE 1 : Créer une DocumentBuilderFactory (slide 33 du cours)
            // ================================================================
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            
            // ================================================================
            // ÉTAPE 2 : Configurer la factory
            // ================================================================
            factory.setValidating(true);  // Active la validation DTD
            factory.setIgnoringElementContentWhitespace(true);  // TRÈS IMPORTANT !
            // Cette ligne ignore les espaces et retours à la ligne entre balises
            // (problème expliqué slides 41-43)
            
            System.out.println("Configuration du parser :");
            System.out.println("  - Validation : OUI (DTD)");
            System.out.println("  - Ignorer espaces : OUI");
            System.out.println();
            
            // ================================================================
            // ÉTAPE 3 : Créer le DocumentBuilder (slide 33 du cours)
            // ================================================================
            DocumentBuilder builder = factory.newDocumentBuilder();
            
            // ================================================================
            // ÉTAPE 4 : Définir un ErrorHandler (slide 34 du cours)
            // ================================================================
            builder.setErrorHandler(new ErrorHandler() {
                @Override
                public void warning(SAXParseException e) throws SAXException {
                    System.err.println("WARNING : " + e.getMessage());
                }
                
                @Override
                public void error(SAXParseException e) throws SAXException {
                    System.err.println("ERROR : " + e.getMessage());
                    throw e;
                }
                
                @Override
                public void fatalError(SAXParseException e) throws SAXException {
                    System.err.println("FATAL : " + e.getMessage());
                    throw e;
                }
            });
            
            // ================================================================
            // ÉTAPE 5 : Parser le fichier XML (slide 33 du cours)
            // ================================================================
            System.out.println("Chargement du fichier XML...");
            long startTime = System.currentTimeMillis();
            
            File fileXML = new File("../../Etape1_Conversion/padchest_images_dtd.xml");
            Document document = builder.parse(fileXML);
            
            long endTime = System.currentTimeMillis();
            System.out.println("Document chargé en " + (endTime - startTime) + " ms");
            
            // ================================================================
            // ÉTAPE 6 : Normaliser le document (slide 33 du cours)
            // ================================================================
            document.getDocumentElement().normalize();
            
            // Afficher l'élément racine (slide 33 du cours)
            Element root = document.getDocumentElement();
            System.out.println("Élément racine : <" + root.getNodeName() + ">");
            System.out.println();
            
            // ================================================================
            // ÉTAPE 7 : Analyser le document
            // ================================================================
            analyserDocument(document);
            
        } catch (Exception e) {
            System.err.println("ERREUR : " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // ========================================================================
    // MÉTHODE D'ANALYSE DU DOCUMENT
    // ========================================================================
    
    public static void analyserDocument(Document document) {
        System.out.println("=".repeat(70));
        System.out.println("ANALYSE DU DOCUMENT DOM");
        System.out.println("=".repeat(70));
        System.out.println();
        
        // ====================================================================
        // Récupérer TOUS les éléments <image>
        // ====================================================================
        // getElementsByTagName() retourne TOUS les éléments avec ce nom
        // peu importe où ils sont dans l'arbre (slide 37 du cours)
        
        NodeList listeImages = document.getElementsByTagName("image");
        int nbImages = listeImages.getLength();
        
        System.out.println("Nombre total d'images : " + nbImages);
        System.out.println("Analyse en cours...");
        System.out.println();
        
        // Variables pour les statistiques
        int nbImagesLocRight = 0;
        Map<String, Integer> labelCounts = new HashMap<>();
        
        // ====================================================================
        // Parcourir toutes les images
        // ====================================================================
        
        for (int i = 0; i < listeImages.getLength(); i++) {
            Node noeudImage = listeImages.item(i);
            
            // Afficher la progression
            if ((i + 1) % 10000 == 0) {
                System.out.println("  Traitement de l'image " + (i + 1) + "/" + nbImages);
            }
            
            // Vérifier que c'est bien un élément (slide 33 du cours)
            if (noeudImage.getNodeType() == Node.ELEMENT_NODE) {
                Element image = (Element) noeudImage;
                
                // ============================================================
                // TRAITEMENT 1 : Récupérer les localisations
                // ============================================================
                // getElementsByTagName() récupère tous les <localization>
                // de cette image (slide 37 du cours)
                
                NodeList localizations = image.getElementsByTagName("localization");
                for (int j = 0; j < localizations.getLength(); j++) {
                    // getTextContent() récupère le texte du nœud (slide 37)
                    String locText = localizations.item(j).getTextContent().trim();
                    
                    if (locText.contains("loc right")) {
                        nbImagesLocRight++;
                        break;  // Une seule fois par image
                    }
                }
                
                // ============================================================
                // TRAITEMENT 2 : Récupérer les labels
                // ============================================================
                
                NodeList labels = image.getElementsByTagName("label");
                for (int j = 0; j < labels.getLength(); j++) {
                    String labelText = labels.item(j).getTextContent().trim();
                    
                    if (!labelText.isEmpty()) {
                        // Compter ce label
                        labelCounts.put(labelText, 
                            labelCounts.getOrDefault(labelText, 0) + 1);
                    }
                }
            }
        }
        
        // ====================================================================
        // AFFICHAGE DES RÉSULTATS
        // ====================================================================
        
        System.out.println();
        System.out.println("=".repeat(70));
        System.out.println("RÉSULTATS DE L'ANALYSE DOM");
        System.out.println("=".repeat(70));
        System.out.println();
        
        // ----------------------------------------------------------------
        // STATISTIQUE 1
        // ----------------------------------------------------------------
        System.out.println("STATISTIQUE 1 : Images avec localisation 'loc right'");
        System.out.println("-".repeat(70));
        System.out.println("Nombre total d'images : " + nbImages);
        System.out.println("Images avec 'loc right' : " + nbImagesLocRight);
        
        if (nbImages > 0) {
            double pourcentage = (nbImagesLocRight * 100.0) / nbImages;
            System.out.println("Pourcentage : " + String.format("%.2f", pourcentage) + "%");
        }
        System.out.println();
        
        // ----------------------------------------------------------------
        // STATISTIQUE 2
        // ----------------------------------------------------------------
        System.out.println("STATISTIQUE 2 : Top 10 des labels les plus fréquents");
        System.out.println("-".repeat(70));
        
        // Trier les labels par fréquence décroissante
        List<Map.Entry<String, Integer>> sortedLabels = new ArrayList<>(labelCounts.entrySet());
        sortedLabels.sort((a, b) -> b.getValue().compareTo(a.getValue()));
        
        // Afficher le top 10
        int rank = 1;
        for (int i = 0; i < Math.min(10, sortedLabels.size()); i++) {
            Map.Entry<String, Integer> entry = sortedLabels.get(i);
            System.out.printf("%2d. %-40s : %7d occurrences\n", 
                rank++, entry.getKey(), entry.getValue());
        }
        
        System.out.println();
        System.out.println("=".repeat(70));
        System.out.println("Analyse terminée !");
        System.out.println("Nombre total de labels distincts : " + labelCounts.size());
        System.out.println("=".repeat(70));
    }
}