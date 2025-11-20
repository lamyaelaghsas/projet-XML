import javax.xml.parsers.*;
import org.xml.sax.*;
import org.xml.sax.helpers.DefaultHandler;
import org.w3c.dom.*;
import java.io.File;
import java.util.*;

/**
 * ============================================================================
 * BENCHMARK : COMPARAISON DES PERFORMANCES SAX vs DOM et DTD vs XSD
 * ============================================================================
 * 
 * Ce programme mesure et compare :
 * 1. Temps d'exécution (SAX vs DOM)
 * 2. Consommation mémoire (SAX vs DOM)
 * 3. Validation DTD vs XSD
 */
public class PerformanceBenchmark {
    
    // ========================================================================
    // HANDLER SAX SIMPLE (pour les tests)
    // ========================================================================
    
    static class SimpleHandler extends DefaultHandler {
        int nbImages = 0;
        int nbLabels = 0;
        private boolean inLabels = false;
        
        @Override
        public void startElement(String uri, String localName, String qName, Attributes attr) {
            if (qName.equals("image")) nbImages++;
            if (qName.equals("labels")) inLabels = true;
            if (qName.equals("label") && inLabels) nbLabels++;
        }
        
        @Override
        public void endElement(String uri, String localName, String qName) {
            if (qName.equals("labels")) inLabels = false;
        }
    }
    
    // ========================================================================
    // MÉTHODE 1 : Test SAX avec DTD
    // ========================================================================
    
    public static ResultatTest testerSAX_DTD(String fichierXML) {
        System.out.println("\n🔍 Test SAX avec validation DTD...");
        
        // Forcer le garbage collector avant le test
        System.gc();
        
        long memoireAvant = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        long tempsDebut = System.currentTimeMillis();
        
        try {
            SAXParserFactory factory = SAXParserFactory.newInstance();
            factory.setValidating(true);  // Validation DTD
            factory.setNamespaceAware(false);
            
            SAXParser parser = factory.newSAXParser();
            SimpleHandler handler = new SimpleHandler();
            
            parser.parse(fichierXML, handler);
            
            long tempsFin = System.currentTimeMillis();
            long memoireApres = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
            
            long tempsExecution = tempsFin - tempsDebut;
            long memoireUtilisee = memoireApres - memoireAvant;
            
            System.out.println("   ✅ Réussi");
            System.out.println("   📊 " + handler.nbImages + " images, " + handler.nbLabels + " labels");
            
            return new ResultatTest("SAX + DTD", tempsExecution, memoireUtilisee, true);
            
        } catch (Exception e) {
            System.out.println("   ❌ Erreur : " + e.getMessage());
            return new ResultatTest("SAX + DTD", 0, 0, false);
        }
    }
    
    // ========================================================================
    // MÉTHODE 2 : Test SAX avec XSD
    // ========================================================================
    
    public static ResultatTest testerSAX_XSD(String fichierXML) {
        System.out.println("\n🔍 Test SAX avec validation XSD...");
        
        System.gc();
        
        long memoireAvant = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        long tempsDebut = System.currentTimeMillis();
        
        try {
            SAXParserFactory factory = SAXParserFactory.newInstance();
            factory.setValidating(false);  // Pas de validation DTD
            factory.setNamespaceAware(true);
            
            // Configuration pour validation XSD
            factory.setFeature("http://xml.org/sax/features/validation", true);
            factory.setFeature("http://apache.org/xml/features/validation/schema", true);
            
            SAXParser parser = factory.newSAXParser();
            SimpleHandler handler = new SimpleHandler();
            
            parser.parse(fichierXML, handler);
            
            long tempsFin = System.currentTimeMillis();
            long memoireApres = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
            
            long tempsExecution = tempsFin - tempsDebut;
            long memoireUtilisee = memoireApres - memoireAvant;
            
            System.out.println("   ✅ Réussi");
            System.out.println("   📊 " + handler.nbImages + " images, " + handler.nbLabels + " labels");
            
            return new ResultatTest("SAX + XSD", tempsExecution, memoireUtilisee, true);
            
        } catch (Exception e) {
            System.out.println("   ❌ Erreur : " + e.getMessage());
            return new ResultatTest("SAX + XSD", 0, 0, false);
        }
    }
    
    // ========================================================================
    // MÉTHODE 3 : Test DOM avec DTD
    // ========================================================================
    
    public static ResultatTest testerDOM_DTD(String fichierXML) {
        System.out.println("\n🔍 Test DOM avec validation DTD...");
        
        System.gc();
        
        long memoireAvant = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        long tempsDebut = System.currentTimeMillis();
        
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setValidating(true);  // Validation DTD
            factory.setIgnoringElementContentWhitespace(true);
            
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document document = builder.parse(new File(fichierXML));
            
            // Compter les éléments
            NodeList images = document.getElementsByTagName("image");
            NodeList labels = document.getElementsByTagName("label");
            
            long tempsFin = System.currentTimeMillis();
            long memoireApres = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
            
            long tempsExecution = tempsFin - tempsDebut;
            long memoireUtilisee = memoireApres - memoireAvant;
            
            System.out.println("   ✅ Réussi");
            System.out.println("   📊 " + images.getLength() + " images, " + labels.getLength() + " labels");
            
            return new ResultatTest("DOM + DTD", tempsExecution, memoireUtilisee, true);
            
        } catch (Exception e) {
            System.out.println("   ❌ Erreur : " + e.getMessage());
            return new ResultatTest("DOM + DTD", 0, 0, false);
        }
    }
    
    // ========================================================================
    // MÉTHODE 4 : Test DOM avec XSD
    // ========================================================================
    
    public static ResultatTest testerDOM_XSD(String fichierXML) {
        System.out.println("\n🔍 Test DOM avec validation XSD...");
        
        System.gc();
        
        long memoireAvant = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        long tempsDebut = System.currentTimeMillis();
        
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setValidating(false);
            factory.setNamespaceAware(true);
            factory.setIgnoringElementContentWhitespace(true);
            
            // Configuration pour validation XSD
            factory.setFeature("http://xml.org/sax/features/validation", true);
            factory.setFeature("http://apache.org/xml/features/validation/schema", true);
            
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document document = builder.parse(new File(fichierXML));
            
            // Compter les éléments
            NodeList images = document.getElementsByTagName("image");
            NodeList labels = document.getElementsByTagName("label");
            
            long tempsFin = System.currentTimeMillis();
            long memoireApres = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
            
            long tempsExecution = tempsFin - tempsDebut;
            long memoireUtilisee = memoireApres - memoireAvant;
            
            System.out.println("   ✅ Réussi");
            System.out.println("   📊 " + images.getLength() + " images, " + labels.getLength() + " labels");
            
            return new ResultatTest("DOM + XSD", tempsExecution, memoireUtilisee, true);
            
        } catch (Exception e) {
            System.out.println("   ❌ Erreur : " + e.getMessage());
            return new ResultatTest("DOM + XSD", 0, 0, false);
        }
    }
    
    // ========================================================================
    // CLASSE POUR STOCKER LES RÉSULTATS
    // ========================================================================
    
    static class ResultatTest {
        String nom;
        long temps;
        long memoire;
        boolean succes;
        
        ResultatTest(String nom, long temps, long memoire, boolean succes) {
            this.nom = nom;
            this.temps = temps;
            this.memoire = memoire;
            this.succes = succes;
        }
    }
    
    // ========================================================================
    // MÉTHODE POUR AFFICHER LES RÉSULTATS
    // ========================================================================
    
    public static void afficherComparaison(List<ResultatTest> resultats) {
        System.out.println("\n");
        System.out.println("=".repeat(80));
        System.out.println("📊 TABLEAU COMPARATIF DES PERFORMANCES");
        System.out.println("=".repeat(80));
        System.out.println();
        
        System.out.printf("%-15s | %15s | %20s | %10s\n", 
            "MÉTHODE", "TEMPS (ms)", "MÉMOIRE (MB)", "STATUT");
        System.out.println("-".repeat(80));
        
        for (ResultatTest r : resultats) {
            if (r.succes) {
                double memoireMB = r.memoire / (1024.0 * 1024.0);
                System.out.printf("%-15s | %15d | %20.2f | %10s\n", 
                    r.nom, r.temps, memoireMB, "✅");
            } else {
                System.out.printf("%-15s | %15s | %20s | %10s\n", 
                    r.nom, "N/A", "N/A", "❌ ÉCHEC");
            }
        }
        
        System.out.println("=".repeat(80));
        System.out.println();
        
        // ====================================================================
        // ANALYSE COMPARATIVE
        // ====================================================================
        
        System.out.println("📈 ANALYSE COMPARATIVE :");
        System.out.println("-".repeat(80));
        
        // Trouver les résultats SAX et DOM avec DTD
        ResultatTest saxDTD = resultats.stream()
            .filter(r -> r.nom.equals("SAX + DTD") && r.succes)
            .findFirst().orElse(null);
        
        ResultatTest domDTD = resultats.stream()
            .filter(r -> r.nom.equals("DOM + DTD") && r.succes)
            .findFirst().orElse(null);
        
        if (saxDTD != null && domDTD != null) {
            System.out.println("\n🔹 SAX vs DOM (avec DTD) :");
            
            // Comparaison temps
            if (saxDTD.temps < domDTD.temps) {
                double ratio = (double) domDTD.temps / saxDTD.temps;
                System.out.printf("   ⚡ SAX est %.2fx plus RAPIDE que DOM\n", ratio);
            } else {
                double ratio = (double) saxDTD.temps / domDTD.temps;
                System.out.printf("   ⚡ DOM est %.2fx plus RAPIDE que SAX\n", ratio);
            }
            
            // Comparaison mémoire
            if (saxDTD.memoire < domDTD.memoire) {
                double ratio = (double) domDTD.memoire / saxDTD.memoire;
                System.out.printf("   💾 SAX utilise %.2fx MOINS de mémoire que DOM\n", ratio);
            } else {
                double ratio = (double) saxDTD.memoire / domDTD.memoire;
                System.out.printf("   💾 DOM utilise %.2fx MOINS de mémoire que SAX\n", ratio);
            }
        }
        
        // Comparaison DTD vs XSD avec SAX
        ResultatTest saxXSD = resultats.stream()
            .filter(r -> r.nom.equals("SAX + XSD") && r.succes)
            .findFirst().orElse(null);
        
        if (saxDTD != null && saxXSD != null) {
            System.out.println("\n🔹 DTD vs XSD (avec SAX) :");
            
            if (saxDTD.temps < saxXSD.temps) {
                double diff = ((double)(saxXSD.temps - saxDTD.temps) / saxDTD.temps) * 100;
                System.out.printf("   📄 DTD est %.1f%% plus rapide que XSD\n", diff);
            } else {
                double diff = ((double)(saxDTD.temps - saxXSD.temps) / saxXSD.temps) * 100;
                System.out.printf("   📄 XSD est %.1f%% plus rapide que DTD\n", diff);
            }
        }
        
        System.out.println();
        System.out.println("=".repeat(80));
    }
    
    // ========================================================================
    // PROGRAMME PRINCIPAL
    // ========================================================================
    
    public static void main(String[] args) {
        System.out.println("╔══════════════════════════════════════════════════════════════════════════════╗");
        System.out.println("║                    BENCHMARK DE PERFORMANCE SAX vs DOM                       ║");
        System.out.println("║                         DTD vs XSD - PadChest                                ║");
        System.out.println("╚══════════════════════════════════════════════════════════════════════════════╝");
        
        // Chemins des fichiers
        String fichierDTD = "../../Etape1_Conversion/padchest_images_dtd.xml";
        String fichierXSD = "../../Etape1_Conversion/padchest_images_xsd.xml";
        
        System.out.println("\n📁 Fichiers à tester :");
        System.out.println("   - " + fichierDTD);
        System.out.println("   - " + fichierXSD);
        
        List<ResultatTest> resultats = new ArrayList<>();
        
        // ====================================================================
        // TESTS
        // ====================================================================
        
        System.out.println("\n" + "=".repeat(80));
        System.out.println("🚀 LANCEMENT DES TESTS");
        System.out.println("=".repeat(80));
        
        // Test 1 : SAX + DTD
        resultats.add(testerSAX_DTD(fichierDTD));
        
        // Test 2 : SAX + XSD
        resultats.add(testerSAX_XSD(fichierXSD));
        
        // Test 3 : DOM + DTD
        resultats.add(testerDOM_DTD(fichierDTD));
        
        // Test 4 : DOM + XSD
        resultats.add(testerDOM_XSD(fichierXSD));
        
        // ====================================================================
        // AFFICHAGE DES RÉSULTATS
        // ====================================================================
        
        afficherComparaison(resultats);
        
        System.out.println("\n💡 RECOMMANDATIONS :");
        System.out.println("-".repeat(80));
        System.out.println("• SAX : Idéal pour les GROS fichiers (économe en mémoire)");
        System.out.println("• DOM : Idéal pour la MANIPULATION (navigation dans l'arbre)");
        System.out.println("• DTD : Plus simple, validation de base");
        System.out.println("• XSD : Plus puissant, typage des données");
        System.out.println("=".repeat(80));
    }
}
