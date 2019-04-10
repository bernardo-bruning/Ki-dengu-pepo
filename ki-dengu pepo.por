programa
{
	inclua biblioteca Matematica --> ma
	inclua biblioteca Graficos --> g
	inclua biblioteca Util --> u
	inclua biblioteca Mouse --> mo
	inclua biblioteca Sons --> s
	inclua biblioteca Teclado --> te
	inclua biblioteca Texto --> tx
	inclua biblioteca Tipos --> tp

	const inteiro TELA_LARGURA = 815
	const inteiro TELA_ALTURA = 540

	funcao inicia_graficos(cadeia titulo, inteiro largura, inteiro altura) {
		g.iniciar_modo_grafico(verdadeiro)
		g.definir_titulo_janela(titulo)
		g.definir_dimensoes_janela(largura , altura)
		limpa_tela(g.COR_PRETO)
	}

	funcao limpa_tela(inteiro cor_fundo) {
		g.definir_cor(cor_fundo)
		g.limpar()
	}

	funcao inicio()
	{
		logico acabou = falso
		inicia_graficos("Jogo", TELA_LARGURA, TELA_ALTURA)
		jogo_apresentacao_loop()
		jogo_principal_loop()
	}

	/**
	 * Apresentação do jogo
	 */
	inteiro dialogo_atual = 1
	inteiro DIALOGO_MAXIMO = 5
	inteiro dialogo_imagem = g.carregar_imagem("dialogo1.png")
	inteiro personagem_maquina = g.carregar_imagem("cientista.png")
	inteiro jogo_apresentacao_musica = s.carregar_som("centrada.mp3")
	
	funcao jogo_apresentacao_controle() {
		se(te.ler_tecla() == te.TECLA_ENTER){ 
			dialogo_atual++
			se(DIALOGO_MAXIMO != dialogo_atual) {
				dialogo_imagem = g.carregar_imagem("dialogo"+ dialogo_atual +".png")
			}
		}
	}

	funcao jogo_apresentacao_loop() {
		s.reproduzir_som(jogo_apresentacao_musica, verdadeiro)
		enquanto(DIALOGO_MAXIMO != dialogo_atual) {
			jogo_apresentacao_desenha()
			jogo_apresentacao_controle() //Atualiza os controles
		}
		s.interromper_som(jogo_apresentacao_musica)
		s.liberar_som(jogo_apresentacao_musica)
	}
	
	funcao jogo_apresentacao_desenha() {
		g.limpar()
		g.desenhar_imagem(150, 190, personagem_maquina)
		g.desenhar_imagem(300, 100, dialogo_imagem)
		g.renderizar()
	}
	
	/*******************************************************/


	/**
	 * Jogo
	 */
	
	/* Define quantos quadros serão desenhados por segundo (FPS) */
	const inteiro TAXA_ATUALIZACAO = 25
	const inteiro JOGO_BORDA = 10

	/* Variáveis utilizadas para controlar o FPS e o tempo de jogo */
	inteiro tempo_inicio = 0, tempo_decorrido = 0, tempo_restante = 0, tempo_quadro = 1000 / TAXA_ATUALIZACAO
	inteiro musica_jogo = s.carregar_som("jogo.mp3")
	inteiro jogo_fundo_vitoria = g.carregar_imagem("vitoria.png")
	inteiro jogo_fundo_derrota = g.carregar_imagem("gameover.png")
	inteiro jogo_principal_tempo_barra = g.carregar_imagem("barratempo.png")
	inteiro jogo_principal_tempo = g.carregar_imagem("indo.png")

	inteiro jogo_qtd_itens = 0
	logico jogo_tempo_acabou = falso
	inteiro jogo_tempo_inicio = 0
	inteiro jogo_tempo_fim = jogo_tempo_inicio  + 30000
	 
	inteiro jogo_fundo = g.carregar_imagem("mapa.png")
	funcao jogo_principal_loop() {
		jogo_principal_iniciar()
		
		enquanto(jogo_qtd_itens != 0 e nao jogo_tempo_acabou) {
			jogo_principal_atualiza()
			jogo_principal_desenha()

			jogo_tempo_acabou = u.tempo_decorrido() >= jogo_tempo_fim
		}

		s.interromper_som(musica_jogo)
		s.liberar_som(musica_jogo)

		g.desenhar_imagem(0, 0, jogo_fundo_derrota)
		se(jogo_qtd_itens == 0) {
			g.desenhar_imagem(0, 0, jogo_fundo_vitoria)
		}
		g.renderizar()

		enquanto(te.ler_tecla() != te.TECLA_ENTER) {}
	}

	funcao jogo_principal_iniciar() {
		jogo_tempo_inicio = u.tempo_decorrido()
		jogo_tempo_fim = u.tempo_decorrido() + 30000
		s.reproduzir_som(musica_jogo, verdadeiro)
		jogo_principal_borda()
		jogo_principal_paredes()
		jogo_principal_item()
	}

	funcao jogo_principal_item() {
		jogo_item_adicionar(40, 60, 0)
		jogo_item_adicionar(80, 90, 1)
		jogo_item_adicionar(500, 345, 3)
		jogo_item_adicionar(500, 30, 3)
		jogo_item_adicionar(80, 420, 2)
		jogo_item_adicionar(40, 340, 0)
		jogo_item_adicionar(550, 70, 1)
		jogo_item_adicionar(600, 400, 2)
		jogo_item_adicionar(400, 400, 3)
		jogo_item_adicionar(300, 20, 0)
		jogo_item_adicionar(200, 400, 0)
		jogo_item_adicionar(750, 400, 1)
	}

	funcao jogo_principal_paredes() {
		jogo_colisao_adicionar(335,0, 65, 143, 0)//COLUNA 1
		jogo_colisao_adicionar(335,261, 65, 279, 0)//COLUNA 2
		jogo_colisao_adicionar(759,0, 65, 256, 0)//COLUNA 3
	}

	funcao jogo_principal_borda() {
		jogo_colisao_adicionar(0,0, JOGO_BORDA, TELA_ALTURA, 0)//ESQUERDA
		jogo_colisao_adicionar(TELA_LARGURA-JOGO_BORDA,0, JOGO_BORDA, TELA_ALTURA, 0)//DIREITA
		jogo_colisao_adicionar(0,0, TELA_LARGURA, JOGO_BORDA, 0)//CIMA
		jogo_colisao_adicionar(0,TELA_ALTURA-JOGO_BORDA-50, TELA_LARGURA, JOGO_BORDA, 0)//BAIXO
	}
	
	funcao jogo_principal_atualiza() {
		personagem_movimento()
	}

	funcao jogo_principal_desenha() {
		g.limpar()		
		
		jogo_fundo_desenhar()
		item_desenhar()
		personagem_desenhar()	
		jogo_principal_tempo_desenhar()	
		
		g.renderizar()

		u.aguarde(1000/60)
	}

	funcao jogo_fundo_desenhar() {
		g.desenhar_imagem(0, 0, jogo_fundo)
	}
	
	funcao jogo_principal_fundo() {
		g.desenhar_imagem(0, 0, jogo_fundo)
	}

	funcao jogo_principal_tempo_desenhar() {
		g.desenhar_imagem(((TELA_LARGURA)/2)-102, TELA_ALTURA-52, jogo_principal_tempo_barra)
		g.desenhar_imagem(((TELA_LARGURA)/2)-65+((jogo_tempo_fim - u.tempo_decorrido()) / 1000)*4, TELA_ALTURA-30, jogo_principal_tempo)
		g.desenhar_texto(TELA_LARGURA - 100, TELA_ALTURA - 10, "Faltam " + (jogo_tempo_fim - u.tempo_decorrido()) / 1000 + " segundo(s)")
	}
	
	/*******************************************************/

	/**
	 * Sistema de colisões
	 */

	const inteiro COLISAO_X = 0
	const inteiro COLISAO_Y = 1
	const inteiro COLISAO_ALTURA = 2
	const inteiro COLISAO_LARGURA = 3
	const inteiro COLISAO_FUNCAO = 4
	const inteiro COLISAO_HABILITADA = 5

	const inteiro MAX_COLICOES = 1000
	inteiro colicoes_tamanho = 0
	inteiro colicoes[MAX_COLICOES][6]
	
	funcao jogo_colisao_funcoes(inteiro x, inteiro y, inteiro largura, inteiro altura, inteiro id_funcao, inteiro indice) {
		escolha(id_funcao) {
			caso 0:
				personagem_colisao(x, y, largura, altura)
			pare
			caso 1:
				personagem_item_colisao(indice)
			pare
		}
	}

	funcao personagem_item_colisao(inteiro indice) {
		se(te.tecla_pressionada(te.TECLA_ESPACO)) {
			itens[indice-7][5] = 1
			colicoes[indice][COLISAO_HABILITADA] = 0
			jogo_qtd_itens--
			s.reproduzir_som(personagem_som_acao, falso)
		}
	}

	funcao jogo_colisao_detectar(inteiro x, inteiro y, inteiro largura, inteiro altura) {
		para(inteiro i=0; i<colicoes_tamanho; i++) {
			se(colicoes[i][COLISAO_HABILITADA] == 1) {
				se(x+largura > colicoes[i][COLISAO_X] e x < colicoes[i][COLISAO_X] + colicoes[i][COLISAO_LARGURA] e y+altura > colicoes[i][COLISAO_Y] e y < colicoes[i][COLISAO_Y] + colicoes[i][COLISAO_ALTURA]) {
					jogo_colisao_funcoes(colicoes[i][COLISAO_X], colicoes[i][COLISAO_Y], colicoes[i][COLISAO_LARGURA], colicoes[i][COLISAO_ALTURA], colicoes[i][COLISAO_FUNCAO],i)
				}
			}
		}
	}
	
	funcao jogo_colisao_adicionar(inteiro x, inteiro y, inteiro largura, inteiro altura, inteiro id_funcao) {
		colicoes[colicoes_tamanho][COLISAO_X] = x
		colicoes[colicoes_tamanho][COLISAO_Y] = y
		colicoes[colicoes_tamanho][COLISAO_ALTURA] = altura
		colicoes[colicoes_tamanho][COLISAO_LARGURA] = largura
		colicoes[colicoes_tamanho][COLISAO_FUNCAO] = id_funcao
		colicoes[colicoes_tamanho][COLISAO_HABILITADA] = 1
		colicoes_tamanho++
	}
	
	/*******************************************************/

	
	/**
	 * Personagem
	 */

	const inteiro PERSONAGEM_RESPIRACAO_ESQUERDA = 0
	const inteiro PERSONAGEM_RESPIRACAO_DIREITA = 1
	const inteiro PERSONAGEM_ANDAR_ESQUERDA = 2
	const inteiro PERSONAGEM_ANDAR_DIREITA = 3
	const inteiro PERSONAGEM_LARGURA = 40
	const inteiro PERSONAGEM_ALTURA = 60
	
	inteiro personagem_x = 200
	inteiro personagem_y = 200
	inteiro personagem_vel = 3
	inteiro personagem_frame_atual = 0
	inteiro personagem_estado_atual = PERSONAGEM_RESPIRACAO_ESQUERDA
	inteiro personagem_estado_ultimo = PERSONAGEM_RESPIRACAO_ESQUERDA
	inteiro personagem_image = g.carregar_imagem("spritep.png")

	inteiro personagem_desenho_aguarde = 10
	inteiro personagem_desenho_inicio = personagem_desenho_aguarde

	logico personagem_direcao_direita = falso

	inteiro personagem_som_acao = s.carregar_som("spell.mp3")
	inteiro personagem_som_andar = s.carregar_som("walk.mp3")

	funcao personagem_colisao(inteiro x, inteiro y, inteiro largura, inteiro altura) {
		logico colidio = falso
		se(te.tecla_pressionada(te.TECLA_D)) { 
			personagem_x -= personagem_vel
		}		

		se(te.tecla_pressionada(te.TECLA_A)) { 
			personagem_x += personagem_vel
		}

		se(te.tecla_pressionada(te.TECLA_S)) { 
			personagem_y -= personagem_vel
		}		

		se(te.tecla_pressionada(te.TECLA_W)) { 
			personagem_y += personagem_vel
		}

	}

	funcao personagem_movimento() {
		se(personagem_direcao_direita) {
			personagem_estado_atual = PERSONAGEM_RESPIRACAO_DIREITA
		}
		senao
		{
			personagem_estado_atual = PERSONAGEM_RESPIRACAO_ESQUERDA
		}

		se(te.tecla_pressionada(te.TECLA_A)) {
			se(personagem_estado_ultimo != PERSONAGEM_ANDAR_ESQUERDA) { 
				personagem_frame_atual = 0		
			}
			personagem_estado_atual = PERSONAGEM_ANDAR_ESQUERDA
			personagem_estado_ultimo = PERSONAGEM_ANDAR_ESQUERDA
			personagem_direcao_direita = falso
			personagem_x -= personagem_vel
		}

		se(te.tecla_pressionada(te.TECLA_D)) {
			se(personagem_estado_ultimo != PERSONAGEM_ANDAR_DIREITA) { 
				personagem_frame_atual = 0
			}
			personagem_estado_atual = PERSONAGEM_ANDAR_DIREITA
			personagem_estado_ultimo = PERSONAGEM_ANDAR_DIREITA
			personagem_direcao_direita = verdadeiro
			personagem_x += personagem_vel
		}


		se(te.tecla_pressionada(te.TECLA_W) ou te.tecla_pressionada(te.TECLA_S)) {
			se(personagem_direcao_direita) {
				personagem_estado_atual = PERSONAGEM_ANDAR_DIREITA
				personagem_estado_ultimo = PERSONAGEM_ANDAR_DIREITA
			}
			senao
			{
				personagem_estado_atual = PERSONAGEM_ANDAR_ESQUERDA
				personagem_estado_ultimo = PERSONAGEM_ANDAR_ESQUERDA
			}
		}

		se(te.tecla_pressionada(te.TECLA_S)) {
			personagem_y += personagem_vel
		}
		se(te.tecla_pressionada(te.TECLA_W)) {
			personagem_y -= personagem_vel
		}
	}

	funcao inteiro personagem_frame_maximo() {
		escolha(personagem_estado_atual) {
			caso PERSONAGEM_RESPIRACAO_ESQUERDA:
			retorne 2
			caso PERSONAGEM_RESPIRACAO_DIREITA:
			retorne 2
			caso PERSONAGEM_ANDAR_ESQUERDA:
			retorne 4
			caso PERSONAGEM_ANDAR_DIREITA:
			retorne 4
		}
		retorne 0
	}
	
	funcao personagem_desenhar() {

		jogo_colisao_detectar(personagem_x, personagem_y, PERSONAGEM_LARGURA, PERSONAGEM_ALTURA)
		
		inteiro xi = personagem_frame_atual * PERSONAGEM_LARGURA
		inteiro yi = personagem_estado_atual * PERSONAGEM_ALTURA
		g.desenhar_porcao_imagem(personagem_x, personagem_y, xi, yi, PERSONAGEM_LARGURA, PERSONAGEM_ALTURA, personagem_image)
		
		se(personagem_desenho_inicio >= personagem_desenho_aguarde) {
			personagem_frame_atual++
			personagem_desenho_inicio = 0
		}
		personagem_desenho_inicio++

		
		se(personagem_frame_atual>=personagem_frame_maximo()) {personagem_frame_atual = 0}
	}

	/*******************************************************/

	/**
	 * Item 28x40
	 */
	inteiro itens[100][6]
	inteiro itens_tamanho = 0
	//inteiro item_imagem_agua = g.carregar_imagem("sagua")
	inteiro item_imagem_garrafa = g.carregar_imagem("sgarrafa.png")
	inteiro item_imagem_balde = g.carregar_imagem("sbalde.png")
	inteiro item_imagem_tonel = g.carregar_imagem("stonel.png")
	inteiro item_imagem_vaso = g.carregar_imagem("svaso.png")

	funcao inteiro item_imagem(inteiro tipo) {
		escolha(tipo) {
			caso 0:
			retorne item_imagem_garrafa
			caso 1:
			retorne item_imagem_balde
			caso 2:
			retorne item_imagem_tonel
			caso 3:
			retorne item_imagem_vaso
		}
		retorne 0
	}
	
	funcao jogo_item_adicionar(inteiro x, inteiro y, inteiro tipo) {
		item_adicionar(x, y,  28, 40, tipo)
		jogo_qtd_itens++
	}

	funcao item_adicionar(inteiro x, inteiro y, inteiro largura, inteiro altura, inteiro tipo) {
		itens[itens_tamanho][0] = x
		itens[itens_tamanho][1] = y
		itens[itens_tamanho][2] = largura
		itens[itens_tamanho][3] = altura
		itens[itens_tamanho][4] = tipo
		itens[itens_tamanho][5] = 0 //Tirou o foco da dengue

		jogo_colisao_adicionar(x, y, altura, largura, 1)
		itens_tamanho++
	}

	funcao item_desenhar() {
		para(inteiro i = 0; i < itens_tamanho; i++) {
			inteiro xi = itens[i][5] * itens[i][2]
			inteiro yi = 0
			g.desenhar_porcao_imagem(itens[i][0], itens[i][1], xi, yi, itens[i][2], itens[i][3], item_imagem(itens[i][4]))
		}
	}
	
	/*******************************************************/
	funcao desenha_imagem(cadeia caminho) {
		inteiro endereco = g.carregar_imagem(caminho)
		g.desenhar_imagem(0, 0, endereco)
	}

	funcao desenha_sprite(inteiro x, inteiro y, inteiro largura, inteiro altura, cadeia caminho, inteiro endereco) {
		inteiro xi = endereco * largura
		g.desenhar_porcao_imagem(x, y, xi, 0, largura, altura, endereco)
	}

	funcao desenha_sprite_sem_fundo(inteiro x, inteiro y, inteiro largura, inteiro altura, inteiro cor, cadeia caminho, inteiro indice) {
		desenha_sprite_com_transformacao(x, y, largura, altura, caminho, indice, cor, 0, falso, falso)
	}

	funcao desenha_sprite_com_transformacao(inteiro x, inteiro y, inteiro largura, inteiro altura, cadeia caminho, inteiro indice, inteiro cor, inteiro rotacao, logico espelhamento_horizontal, logico espelhamento_vertical) {
		inteiro xi = indice * largura
		inteiro endereco = g.carregar_imagem(caminho)
		
		endereco = g.transformar_porcao_imagem(endereco, xi, 0, largura, altura, espelhamento_horizontal, espelhamento_vertical, rotacao, cor)
		g.desenhar_imagem(x, y, endereco)
	}
}

/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 4866; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */