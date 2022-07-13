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
/*
 XmlSerializer xsSubmit = new XmlSerializer(typeof(MyObject));
 var subReq = new MyObject();
 var xml = "";

 using(var sww = new StringWriter())
 {
     using(XmlWriter writer = XmlWriter.Create(sww))
     {
         xsSubmit.Serialize(writer, subReq);
         xml = sww.ToString(); // Your XML
     }
 }
 */