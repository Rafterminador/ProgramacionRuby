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
  }
cola_ventas = {
    tope: nil,
    final: nil,
    max: 20,
    posicion: 0
}
cola_historial_ventas = {
    tope: nil,
    fondo: nil,
    max: 2,
    posicion: 0
}
def regular_ultimas_ventas(cola_historial_ventas, cod_col, isbn, autor, nombre, precio)
    if cola_historial_ventas[:posicion] < cola_historial_ventas[:max]
        Necesario.ingresar_historial(cola_historial_ventas, cod_col, isbn, autor, nombre, precio)
    end
end
def buscar_venta(cola_historial_ventas, cod)
    
end
def registrar_libros_mismo_isbn(cola_libros, n, i, a, pr)
    aux = cola_libros[:tope]
    ya_estaba = false
    for j in (0 .. cola_libros[:size] - 1)
        if aux[:isbn] == i
            aux[:existencia] += 1
            ya_estaba = true
        end
        break if aux[:siguiente] == nil
        aux = aux[:siguiente]
    end
    if ya_estaba == false
        cola_libros[:size] += 1
        registrar_libros(cola_libros, n, i, a, pr)
    end
end
def registrar_libros(cola_libros, n, i, a, pr)
    if cola_libros[:tope] == nil && cola_libros[:fondo] == nil
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
end 
def eliminar_libro_existencia(cola_libros, isbn)
    aux = cola_libros[:tope]
    for i in (0 .. cola_libros[:size] - 1)
        break if aux[:isbn] == isbn
        break if aux[:siguiente] == nil
        aux = aux[:siguiente]
    end
    if aux[:siguiente] == nil
        #Para eliminar si el tope tiene 0 existencias
        if aux[:existencia] == 0
            cola_libros[:tope] = nil
            cola_libros[:fondo] = nil 
        end
    elsif aux[:siguiente] == cola_libros[:fondo]
        if aux[:existencia] == 0
            cola_libros[:tope] = cola_libros[:fondo]
            cola_libros[:fondo] = cola_libros[:tope]
        end
    end
end  
def ventas(cola_libros, cola_historial_ventas)
    Necesario.limpiar_pantalla
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
                cod = rand(1000000)
                cod_col = cod
                puts 'isbn del libro:'
                puts aux[:isbn]
                puts 'nombre del libro:'
                puts aux[:nombre]
                puts 'precio del libro:'
                puts aux[:precio]
                puts "Su código de venta es: #{cod_col}" 
                aux[:existencia] -= 1
                auxtotal = aux[:precio]
                sumtotal = auxtotal+sumtotal
                contv +=1
                cola_historial_ventas[:posicion] += 1
                cola_libros[:size] -= 1
                regular_ultimas_ventas(cola_historial_ventas, cod_col, aux[:isbn], aux[:autor], aux[:nombre], aux[:precio])
                eliminar_libro_existencia(cola_libros, aux[:isbn])
                puts 'el total hasta ahora es de:'
                puts sumtotal
                gets
            else
                puts ' no hay en existencia'
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
            end
            break if aux[:siguente] == nil
        end
        aux = aux[:siguiente]
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
                puts cola_libros[:size]
                gets
            elsif opcion1 == 'D'
                Necesario.mostrar_autores(cola_autores, cola_libros)
            elsif opcion1 == 'E'
                Necesario.buscar_isbn(cola_libros)
            elsif opcion1 == 'F'
                if cola_autores[:tope] != nil
                    Necesario.buscar_autor(cola_libros, cola_autores)
                else
                    puts 'No hay autores a buscar'
                    gets
                end
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
                if cola_libros[:tope] != nil
                    ventas(cola_libros, cola_historial_ventas)
                else
                    puts 'No hay libros para vender'
                    gets
                end
            elsif opcion2 == 'B'
                puts cola_historial_ventas[:tope]
                gets
            end
            Necesario.limpiar_pantalla
        end while opcion2 != "D"
    end
end while opcion !=3
