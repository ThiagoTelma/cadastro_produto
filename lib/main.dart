import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Produtos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FormularioPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  String categoriaProduto = 'Roupas';
  // Campos de Texto
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoCompraController = TextEditingController();
  final TextEditingController _precoVendaController = TextEditingController();
  final TextEditingController _estoqueController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _imagemController = TextEditingController();

  // Campos de seleção
  bool _ativo = true; // true = ativo, false = inativo
  bool _emPromocao = false;
  double _desconto = 0.0;

  List<Map<String, dynamic>> dadosFormulario = [];

  // Função de validação antes de enviar
  void _validarFormulario() {
    if (_nomeController.text.isEmpty) {
      _exibirSnackbar("Nome do produto é obrigatório!");
      return;
    }
    if (_precoCompraController.text.isEmpty) {
      _exibirSnackbar("Preço de compra é obrigatório!");
      return;
    }
    if (_precoVendaController.text.isEmpty) {
      _exibirSnackbar("Preço de venda é obrigatório!");
      return;
    }
    if (_estoqueController.text.isEmpty) {
      _exibirSnackbar("A quantidade em estoque é obrigatório!");
      return;
    }
    if (_descricaoController.text.isEmpty) {
      _exibirSnackbar("Descrição é obrigatório!");
      return;
    }
    dadosFormulario.add({
      "nome": _nomeController.text,
      "preco_compra": _precoCompraController.text,
      "preco_venda": _precoVendaController.text,
      "estoque": _estoqueController.text,
      "descricao": _descricaoController.text,
      "imagem": _imagemController.text,
      "ativo": _ativo,
      "em_promocao": _emPromocao,
      "desconto": _emPromocao ? _desconto : null,
    });

    //Navega para a tela de detalhes
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesPage(dadosFormulario: dadosFormulario),
      ),
    );
  }

  //Função para exibir Snackbar
  void _exibirSnackbar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            mensagem,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ),
    );
  }

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        categoriaProduto = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Cadastro de Produtos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100, // Cor de fundo do dropdown
            border: Border.all(
              color: Colors.grey.shade400, // Cor da borda
              width: 1.5, // Espessura da borda
            ),
            borderRadius: BorderRadius.circular(8), // Bordas arredondadas
          ),
          child: ListView(
            children: [
              Text(
                'Informações do Produto',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Nome do Produto
              _buildTextField(
                controller: _nomeController,
                labelText: 'Nome do Produto',
                hintText: '',
              ),
              const SizedBox(height: 10),
              // Preço de Compra
              _buildTextField(
                controller: _precoCompraController,
                labelText: 'Preço de compra',
                hintText: '',
              ),
              const SizedBox(height: 10),
              // Preço de Venda
              _buildTextField(
                controller: _precoVendaController,
                labelText: 'Preço de venda',
                hintText: '',
              ),
              const SizedBox(height: 10),
              // Quantidade em Estoque
              _buildTextField(
                controller: _estoqueController,
                labelText: 'Quantidade em Estoque',
                hintText: '',
              ),
              const SizedBox(height: 10),
              // Descrição
              _buildTextField(
                maxLines: 3,
                controller: _descricaoController,
                labelText: 'Descrição',
                hintText: '',
              ),
              const SizedBox(height: 10),
              // Categoria (DropdownButton)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: categoriaProduto,
                    isExpanded: true,
                    items:
                        [
                              'Eletrônicos',
                              'Roupas',
                              'Calçados',
                              'Alimentos',
                              'Livros',
                            ]
                            .map(
                              (cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        categoriaProduto = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // URL da Imagem
              _buildTextField(
                controller: _imagemController,
                labelText: 'URL da Imagem',
                hintText: '',
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text("Produto ativo"),
                value: _ativo,
                onChanged: (ativo) {
                  setState(() {
                    _ativo = ativo!;
                  });
                },
              ),

              const SizedBox(height: 10),
              SwitchListTile(
                title: const Text("Produto em Promoção"),
                value: _emPromocao,
                onChanged: (bool? promocao) {
                  setState(() {
                    _emPromocao = promocao!;
                  });
                },
              ),
              if (_emPromocao) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Desconto (%) - Atual: $_desconto %"),
                ),
                Slider(
                  value: _desconto,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  label: _desconto.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _desconto = value;
                    });
                  },
                ),
              ] else
                ...[],
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  _validarFormulario();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  "Cadastrar Produto",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para criar os TextFields com estilo uniforme
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.purple, // Cor quando o campo está em foco
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class DetalhesPage extends StatelessWidget {
  final List<Map<String, dynamic>> dadosFormulario;

  const DetalhesPage({super.key, required this.dadosFormulario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Cadastro"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormularioPage()),
          );
        },
        label: Text('Novo produto', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: dadosFormulario.length,
          itemBuilder: (context, index) {
            final cadastro = dadosFormulario[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.label, color: Colors.deepPurpleAccent),
                        const SizedBox(width: 10),
                        Text(
                          '${cadastro['nome']}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey[400], thickness: 1),
                    Image.network('${cadastro['imagem']}'),
                    Divider(color: Colors.grey[400], thickness: 1),
                    Row(
                      children: [
                        Icon(
                          Icons.shopping_cart_sharp,
                          color: Colors.deepPurpleAccent,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Preço de compra: ${cadastro['preco_compra']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: Colors.deepPurpleAccent,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Preço de venda: ${cadastro['preco_venda']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.inventory, color: Colors.deepPurpleAccent),
                        const SizedBox(width: 10),
                        Text(
                          'Quantidade: ${cadastro['estoque']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
