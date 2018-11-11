require 'rubygems'
require 'terminal-table/import'
require_relative 'necesario.rb'
cola_autores = {
    tope: nil,
    fondo: nil,
    max: 5,
    posicion: 0,
}
cola_libros = {
    tope: nil,
    final: nil,
    size: 0,
    posicion:0
  }
cola_ventas = {
    tope: nil,
    final: nil,
    max: 20,
    codigo: nil
}
def buscar_autor(cola_libros, cola_autores)
    Necesario.limpiar_pantalla
    esta = false
    aux = cola_autores[:tope]
    aux2 = cola_libros[:tope]
    if cola_autores[:tope] == nil && cola_autores[:fondo] == nil
      puts table([{:value => "Ruby BookStore",:alignment => :center}] , ['No hay autores a mostrar'])
    else
        puts 'Ingrese el autor a buscar'
        x = gets.chomp.upcase
        for i in (0 .. cola_autores[:posicion] - 1)
            if aux[:valor] == x
            esta = true
            puts "El autor es: #{aux[:valor]}"
            puts "Sus libros que tiene son: "
            for i in (0 .. cola_libros[:size] - 1)
                if aux[:valor] == aux2[:autor]
                    print "#{aux2[:nombre]}, "
                end
                break if aux2[:siguiente] == nil
                aux2 = aux2[:siguiente]
            end
            end
            aux2 = cola_libros[:tope]
            break if aux2[:siguiente] == nil
            aux = aux[:siguiente]
        end
    end
    if esta == false && cola_autores[:tope] != nil
        puts table([{:value => "Ruby BookStore",:alignment => :center}] , ['Su autor no se encuentra en la base de datos'])
    end
    gets
end
def buscar_isbn(cola_libros)
    Necesario.limpiar_pantalla
    if Necesario.vacia(cola_libros)
      puts table([{:value => "Ruby BookStore",:alignment => :center}] , ['No hay libros a buscar'])
    else
      puts table([{:value => "Ruby BookStore",:alignment => :center}] , ['Que libro desea buscar? abajo ingrese su isbn'])
        isbn = gets.to_i
        esta = false
        aux2 = cola_libros[:tope]
        for i in (0 .. cola_libros[:size])
            if isbn == aux2[:isbn]
                esta = true
                aux3 = aux2
            end
            break if aux2[:siguiente] == nil
            aux2 = aux2[:siguiente]
        end
        if esta == true
            puts "Su isbn es: #{aux3[:isbn]}"
            puts "Su nombre es: #{aux3[:nombre]}"
            puts "Su autor es: #{aux3[:autor]}"
            puts "Su precio es: #{aux3[:precio]}"
            puts "Su existencias son: "#Aqui llamamos a la funcion existencias
        else
            puts 'El isbn que ingreso es invalido o no hay existencias'
        end
    end
    gets
end
def registrar_libros(cola_libros, n, i, a, pr)
    if Necesario.vacia(cola_libros)
        nuevo_libro = {
        nombre: n,
        isbn: i,
        autor: a,
        precio: pr,
        existencia: 1,
        posicion: 0,
        siguiente: nil
        }
        cola_libros[:tope] = nuevo_libro
        cola_libros[:final] = nuevo_libro
    else
        nuevo_libro = {
        nombre: n,
        isbn: i,
        autor: a,
        precio: pr,
        existencia: 1,
        posicion: cola_libros[:size],
        siguiente: nil
        }
        ultimo_libro = cola_libros[:final]
        ultimo_libro[:siguiente] = nuevo_libro
        cola_libros[:final] = nuevo_libro
    end
    cola_libros[:size] += 1
    aux = cola_libros[:tope]
    valor = false
    loop do
        siguiente = aux[:siguiente]
        isbn = aux[:isbn]
        if aux[:siguiente] == nil
            break
        else
            if isbn == siguiente[:isbn]
                aux[:existencia] += 1
                valor = true
                #break
            end
        end
        aux = aux[:siguiente]
    end
    if valor == true
        for i in (0..aux[:posicion] + 1)
            eliminar_libro(cola_libros)
        end
    end
end
def eliminar_libro(cola_libros)
    aux = cola_libros[:tope]
    siguiente = aux[:siguiente]
    siguiente = cola_libros[:tope]
    aux[:siguiente] = nil
end  
def ventas(cola_libros,cola_ventas)
    Necesario.limpiar_pantalla
    # puts 'codigo de compra:'
    cod = rand(1000000)
    cod_col = cod
    puts table([{:value => "Ruby BookStore",:alignment => :center}] , ['Ingrese el isbn del libro'])
    isbn_ventas = gets.chomp.to_i
    aux = cola_libros[:tope]
    esta1 = false
    hay_exis = false
    sumtotal=0
    contv = 1
    for i in (0 .. cola_libros[:size] - 1)
        if isbn_ventas == aux[:isbn]
            if aux[:existencia] > 0
                puts 'isbn del libro:'
                puts aux[:isbn]
                puts 'nombre del libro:'
                puts aux[:nombre]
                puts 'precio del libro:'
                puts aux[:precio]
                aux[:existencia] -= 1
                auxtotal = aux[:precio]
                sumtotal = auxtotal+sumtotal
                contv +=1
                puts 'el total hasta ahora es de:'
                puts sumtotal
            else
                puts ' no hay en existencia'
            end
            puts '¿Desea ingresar otro libro?'
            puts '1. si'
            puts '2. no'
            opcionv = gets.chomp.to_i
            if opcionv == 1
                ventas(cola_libros,cola_ventas)
            else
                if contv >= 3
                    puts 'codigo de venta:'
                    puts cod
                    puts 'el total es de:'
                    restotal = sumtotal * 0.10
                    sumtotal= restotal - sumtotal
                    puts sumtotal
                end
                if contv >= 4
                    puts 'codigo de venta:'
                    puts cod
                    puts 'el total es de:'
                    restotal = sumtotal * 0.20
                    sumtotal= restotal - sumtotal
                    puts sumtotal
                end
            break if aux[:siguente] == nil
            aux = aux[:sigiuente]
            end
        end
    end
end
begin
    Necesario.limpiar_pantalla
    puts table([{:value => "Ruby BookStore",:alignment => :center}] , ['1. Administración de libros'] , ['2. Control de ventas'], ['3. Salir'])
    opcion = gets.chomp.to_i
    if opcion == 1
        Necesario.limpiar_pantalla
        begin
          puts table([{:value => "Ruby BookStore",:alignment => :center}] , ['A. Registro de libros nuevos: '] , ['B. Registro de autores: '], ['C. Listado de libros: '],
            ['D. Listado de autores: '], ['E. Buscar libro: '], ['F. Buscar autor: '] , ['G. salir'])
            opcion1 = gets.chomp.upcase
            if opcion1 == 'A'
                Necesario.validar_autores(cola_autores, 1, cola_libros)
            elsif opcion1 == 'B'
                Necesario.validar_autores(cola_autores, 0, cola_libros)
            elsif opcion1 == 'C'
                puts cola_libros[:tope]
                gets
            elsif opcion1 == 'D'
                Necesario.mostrar_autores(cola_autores, cola_libros)
            elsif opcion1 == 'E'
                buscar_isbn(cola_libros)
            elsif opcion1 == 'F'
                buscar_autor(cola_libros, cola_autores)
            end
            Necesario.limpiar_pantalla
        end while opcion1 != 'G'
    elsif opcion == 2
        Necesario.limpiar_pantalla
        begin
            puts table([{:value => "Ruby BookStore",:alignment => :center}] , ['A. Registrar una venta'] , ['B. Buscar una venta'], ['C. Listado de ventas'],
            ['D. Salir'])
            opcion2 = gets.chomp.upcase
            if opcion2 == 'A'
                ventas(cola_libros,cola_ventas)
            end
            Necesario.limpiar_pantalla
        end while opcion2 != "D"
    end
end while opcion !=3
