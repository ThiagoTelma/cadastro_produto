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
  String _dropdownValue = 'Eletrônicos';

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
  }

  //Função para exibir Snackbar
  void _exibirSnackbar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), duration: const Duration(seconds: 2)),
    );
  }

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
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
                    items: [
                      DropdownMenuItem(
                        value: 'Eletrônicos',
                        child: Text('Eletrônicos'),
                      ),
                      DropdownMenuItem(
                        value: 'Alimentos',
                        child: Text('Alimentos'),
                      ),
                      DropdownMenuItem(
                        value: 'Saúde e beleza',
                        child: Text('Saúde e beleza'),
                      ),
                      DropdownMenuItem(value: 'Livros', child: Text('Livros')),
                      DropdownMenuItem(
                        value: 'Roupas e acessórios',
                        child: Text('Roupas e acessórios'),
                      ),
                    ],
                    value: _dropdownValue,
                    onChanged: dropdownCallback,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    dropdownColor: Colors.white,
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
