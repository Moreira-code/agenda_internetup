import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String momColumn = "momColumn";
final String cpfColumn = "cpfColumn";
final String rgColumn = "rgColumn";
final String datebornColumn = "datebornColumn";
final String andressColumn = "andressColumn";
final String phoneColumn = "phoneColumn";
final String noteColumn = "noteColumn";
final String validColumn = "validColumn";
final String planColumn = "planColumn";
final String costColumn = "costColumn";
final String emailColumn = "emailColumn";
final String imgColumn  = "imgColumn";

class ContactHelper{

  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async{
    if(_db != null){
      return _db; //retorna o banco
    } else {
      _db = await initDb(); // inicializa o banco

      return _db;
    }

  }

  //Criação do Banco

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contactsnew.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT,"
            "$momColumn TEXT, $cpfColumn TEXT, $rgColumn TEXT, $datebornColumn DATE,"
            "$andressColumn TEXT, $phoneColumn TEXT, $noteColumn TEXT, $validColumn TEXT,"
            "$planColumn TEXT, $costColumn TEXT, $emailColumn TEXT, $imgColumn TEXT)"
      );
    });

  }

  Future<Contact> saveContact(Contact contact) async{
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;

  }

  Future<Contact> getContact(int id) async{
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contactTable,  //obtendo as colunas que quero
    columns: [idColumn, nameColumn, momColumn, cpfColumn, rgColumn, datebornColumn, andressColumn, phoneColumn, noteColumn, validColumn, planColumn, costColumn, emailColumn, imgColumn],
    where:  "$idColumn = ?",
    whereArgs: [id]);

    if(maps.length> 0){
      return Contact.fromMap(maps.first); //Se tiver mais de um elemento ele retorna um contato.

    } else {
        return null;

    }

  }

  Future<int> deleteContact(int id) async{ //deleta o contato
    Database dbContact = await db;
    return await dbContact.delete(contactTable, where: "$idColumn = ?", whereArgs:  [id]);

  }

  Future<int> updateContact(Contact contact) async{
    Database dbContact = await db;
    return await dbContact.update(contactTable, contact.toMap(),
        where: "$idColumn = ?",
        whereArgs: [contact.id]);

  }

  Future<List> getAllContacts() async{ //PEGANDO TODOS OS CONTATOS
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery(" SELECT * FROM $contactTable");
    List<Contact> listContact = List();
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));

    }
    return listContact;

  }

  Future<int> getNumber() async{ //obtendo a contagem e quantidade de elementos da tabela
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));

  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();

  }
}

// table id   name    nome_da_mae   cpf   rg    data_de_nascimento    endereço    phone   recado    vencimento_do_plano   nome_do_plano   preço_do_plano    email   imagem_contato
//       0    Lucas   Cleides       038   607   01/05/1996            centro      3525    oi        01/05/1196            premium         205.00            lucc    /images/
class Contact {

  int id;
  String name;
  String mom;
  String cpf;
  String rg;
  String dateborn;
  String andress;
  String phone;
  String note;       //recado
  String valid;      //vencimento
  String plan;
  String cost;       //taxa
  String email;
  String img;  //imagem

  Contact();

  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    mom = map[momColumn];
    cpf = map[cpfColumn];
    rg = map[rgColumn];
    dateborn = map[datebornColumn];
    andress = map[andressColumn];
    phone = map[phoneColumn];
    note = map[noteColumn];
    valid = map[validColumn];
    plan = map[planColumn];
    cost = map[costColumn];
    email = map[emailColumn];
    img = map[imgColumn];


  }

  Map toMap(){

    Map<String, dynamic> map = {
      nameColumn: name,
      momColumn: mom,
      cpfColumn: cpf,
      rgColumn: rg,
      datebornColumn: dateborn,
      andressColumn: andress,
      phoneColumn: phone,
      noteColumn: note,
      validColumn: valid,
      planColumn: plan,
      costColumn: cost,
      emailColumn: email,
      imgColumn: img

    };
    if(id != null){
      map[idColumn] = id;

    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id $id, name: $name, mom: $mom, cpf: $cpf, rg: $rg, dateborn: $dateborn, andress: $andress, phone: $phone, note: $note, valid: $valid, plan: $plan, cost: $cost, email: $email, image: $img)";
  }


}