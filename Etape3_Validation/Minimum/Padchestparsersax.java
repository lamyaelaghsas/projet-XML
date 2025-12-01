import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.helpers.DefaultHandler;
import java.util.*;

/**
 * ============================================================================
 * PARSER SAX POUR PADCHEST
 * ============================================================================
 * 
 * Ce parser calcule :
 * 1. Nombre d'images avec localisation "loc right"
 * 2. Top 10 des labels les plus fréquents
 */
public class PadChestParserSAX extends DefaultHandler {
    
    // ========================================================================
    // VARIABLES POUR LES STATISTIQUES 
    // ========================================================================
    
    private int nbImages = 0;                           // Compteur d'images
    private int nbImagesLocRight = 0;                   // Images avec "loc right"
    private Map<String, Integer> labelCounts = new HashMap<>();  // Compteur de labels
    
    // ========================================================================
    // VARIABLES TEMPORAIRES (pour suivre où on est dans le XML)
    // ========================================================================
    
    private String currentElement = "";                 // Élément actuel
    private StringBuilder currentValue = new StringBuilder();  // Texte accumulé
    private boolean inLocalizations = false;            // Sommes-nous dans <localizations> ?
    private boolean inLabels = false;                   // Sommes-nous dans <labels> ?
    
    // Compteur de tags (comme dans le cours slide 22)
    private int cptTags = 0;
    
    // ========================================================================
    // MÉTHODE 1 : startDocument() - Début du parsing
    // ========================================================================
    // Appelée UNE SEULE FOIS au début 
    
    @Override
    public void startDocument() throws SAXException {
        System.out.println("** Début du document **");
        System.out.println("Le parser SAX démarre...");
        System.out.println();
    }
    
    // ========================================================================
    // MÉTHODE 2 : startElement() - Balise ouvrante
    // ========================================================================
    // Appelée à chaque fois qu'on rencontre <tag> 
    
    @Override
    public void startElement(String uri, String localName, String qName, Attributes attr) 
            throws SAXException {
        
        // Mémoriser l'élément actuel
        currentElement = qName;
        
        // Réinitialiser la valeur courante
        currentValue.setLength(0);
        
        // Incrémenter le compteur de tags 
        cptTags++;
        
        // ----------------------------------------------------------------
        // TRAITEMENT : Détection de <image>
        // ----------------------------------------------------------------
        if (qName.equals("image")) {
            nbImages++;
            
            // Afficher la progression tous les 10000 éléments
            if (nbImages % 10000 == 0) {
                System.out.println("  Traitement de l'image " + nbImages + "...");
            }
            
            // Récupérer l'attribut "id" si présent (comme dans le cours slide 23)
            String id = attr.getValue("id");
            if (id != null) {
                // On peut utiliser l'ID si nécessaire
            }
        }
        
        // ----------------------------------------------------------------
        // TRAITEMENT : Détection de <localizations>
        // ----------------------------------------------------------------
        if (qName.equals("localizations")) {
            inLocalizations = true;
        }
        
        // ----------------------------------------------------------------
        // TRAITEMENT : Détection de <labels>
        // ----------------------------------------------------------------
        if (qName.equals("labels")) {
            inLabels = true;
        }
    }
    
    // ========================================================================
    // MÉTHODE 3 : characters() - Contenu textuel
    // ========================================================================
    // Appelée pour récupérer le texte entre <tag> et </tag> 
    
    @Override
    public void characters(char[] ch, int start, int length) throws SAXException {
        // Convertir le tableau de caractères en String
        String chaine = new String(ch, start, length);
        
        // Ajouter au contenu actuel
        // Note : characters() peut être appelée PLUSIEURS FOIS pour un même élément !
        if (!currentElement.isEmpty()) {
            currentValue.append(chaine);
        }
    }
    
    // ========================================================================
    // MÉTHODE 4 : endElement() - Balise fermante
    // ========================================================================
    // Appelée à chaque fois qu'on rencontre </tag> 
    
    @Override
    public void endElement(String uri, String localName, String qName) throws SAXException {
        
        // Récupérer et nettoyer le contenu textuel
        String value = currentValue.toString().trim();
        
        // Incrémenter le compteur de tags (comme dans le cours)
        cptTags++;
        
        // ----------------------------------------------------------------
        // TRAITEMENT : Fin de <localization> - COMPTAGE DES LOC RIGHT
        // ----------------------------------------------------------------
        if (qName.equals("localization") && inLocalizations) {
            // Si le texte contient "loc right", on compte cette image
            if (value.contains("loc right")) {
                nbImagesLocRight++;
            }
        }
        
        // ----------------------------------------------------------------
        // TRAITEMENT : Fin de <label> - COMPTAGE DES LABELS 
        // ----------------------------------------------------------------
        if (qName.equals("label") && inLabels) {
            if (!value.isEmpty()) {
                // Compter ce label
                // getOrDefault retourne 0 si le label n'existe pas encore
                labelCounts.put(value, labelCounts.getOrDefault(value, 0) + 1);
            }
        }
        
        // ----------------------------------------------------------------
        // SORTIE DES SECTIONS
        // ----------------------------------------------------------------
        if (qName.equals("localizations")) {
            inLocalizations = false;
        }
        
        if (qName.equals("labels")) {
            inLabels = false;
        }
        
        // Réinitialiser l'élément actuel
        currentElement = "";
    }
    
    // ========================================================================
    // MÉTHODE 5 : endDocument() - Fin du parsing
    // ========================================================================
    // Appelée UNE SEULE FOIS à la fin 
    
    @Override
    public void endDocument() throws SAXException {
        System.out.println();
        System.out.println("** Fin du document **");
        System.out.println("Nombre total de tags traités : " + cptTags);
    }
    
    // ========================================================================
    // GESTION DES ERREURS (ErrorHandler)
    // ========================================================================
    
    @Override
    public void warning(SAXParseException e) throws SAXException {
        System.err.println("WARNING : " + e.getMessage());
    }
    
    @Override
    public void error(SAXParseException e) throws SAXException {
        System.err.println("ERROR : " + e.getMessage());
        throw e;  // On relance l'exception
    }
    
    @Override
    public void fatalError(SAXParseException e) throws SAXException {
        System.err.println("FATAL : " + e.getMessage());
        throw e;  // On relance l'exception
    }
    
    // ========================================================================
    // MÉTHODE POUR AFFICHER LES RÉSULTATS
    // ========================================================================
    
    public void afficherResultats() {
        System.out.println();
        System.out.println("=".repeat(70));
        System.out.println("RÉSULTATS DU PARSING SAX");
        System.out.println("=".repeat(70));
        System.out.println();
        
        // ----------------------------------------------------------------
        // STATISTIQUE 1 : Images avec "loc right"
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
        // STATISTIQUE 2 : Top 10 des labels
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
    
    // ========================================================================
    // PROGRAMME PRINCIPAL
    // ========================================================================
    
    // PROGRAMME PRINCIPAL
    public static void main(String[] args) {

        System.out.println("=".repeat(70));
        System.out.println("PARSER SAX - Analyse du fichier PadChest XML");
        System.out.println("=".repeat(70));
        System.out.println();

        try {

            // ============================================================
            // ÉTAPE 1 : Créer une SAXParserFactory
            // ============================================================
            SAXParserFactory factory = SAXParserFactory.newInstance();

            // ============================================================
            // ÉTAPE 2 : Configurer la factory
            // ============================================================
            factory.setValidating(true);   // Validation DTD activée
            factory.setNamespaceAware(false);

            // ============================================================
            // ÉTAPE 3 : Créer un SAXParser
            // ============================================================
            SAXParser saxParser = factory.newSAXParser();

            // ============================================================
            // ÉTAPE 4 : Créer un handler
            // ============================================================
            PadChestParserSAX handler = new PadChestParserSAX();

            // ============================================================
            // ÉTAPE 5 : Définir le chemin du XML ICI (à la place de args[0])
            // ============================================================
            String xmlPath = "../../Etape1_Conversion/padchest_images_dtd.xml";
            System.out.println("Fichier analysé : " + xmlPath);

            // Lancer le parsing
            System.out.println("Début du parsing...");
            long startTime = System.currentTimeMillis();

            saxParser.parse(xmlPath, handler);

            long endTime = System.currentTimeMillis();
            long duration = endTime - startTime;

            System.out.println("\nParsing terminé en " + duration + " ms\n");

            // ============================================================
            // ÉTAPE 6 : Afficher les résultats
            // ============================================================
            handler.afficherResultats();

        } catch (Exception e) {
            System.err.println("ERREUR : " + e.getMessage());
            e.printStackTrace();
        }
    }
}