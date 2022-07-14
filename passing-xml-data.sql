-- En lugar de crear un input de múltiples variables 
-- es posible pasar como parámetro a los procedimientos una estructura XML (string) que contenga los datos

declare @xml XML = '<root><element>
                            <nom></nom>
                            <ape></ape>
                          </element>
                    </root>'

-- Ejemplo de parseo XQuery
select n.value('nom[1]', 'varchar(max)') [NOM],
       n.value('ape[1]', 'varchar(max)') [APE]
from @xml.nodes('root/element') as p(n)


-- Desde .net se puede serializar un modelo en XML y pasarlo al procedimiento almacenado anterior
-- Código de ejemplo .net 5: 

/*
using com.rorisoft.db;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml;
using System.Xml.Serialization;

namespace ConsoleAppPruebas
{
    class TestXML
    {

        public static void Main(string[] args)
        {
            Console.WriteLine("Test XML to BBDD");

            rootXML datos = new rootXML();
            datos.lista = Enumerable.Range(1, 100).Select(x => new modeloXML() { text = string.Concat("texto_",x.ToString()), value = x }).ToList<modeloXML>();

            XmlSerializer xsSubmit = new XmlSerializer(typeof(rootXML));
            var xml = "";

            using (var sww = new StringWriter())
            {
                using (XmlWriter writer = XmlWriter.Create(sww))
                {
                    xsSubmit.Serialize(writer, datos);
                    xml = sww.ToString(); // Your XML
                }
            }

            using (DB db = DBFactory.crear(DBFactory.tipodb.sql_server, ""))
            {
                db.conectar();

                db.setProcedimientoAlmacenado("SP_IMPORT_XML_DATA");
                db.addParameter("@DATA", xml);

                int r = db.ejecutarQuery();
            }
            Console.ReadKey();
        }
    }

    [XmlRoot("data")]
    public class rootXML
    {
        [XmlElement("node")]
        public List<modeloXML> lista { get; set; }
    }
    
    public class modeloXML 
    {
        [XmlElement]
        public string text { get; set; }
        [XmlElement]
        public int value { get; set; }
        
        
    }
}

 */