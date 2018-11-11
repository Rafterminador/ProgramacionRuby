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
    #Para que asi se almacenen las ultimas 20 ventas
    max: 21,
    posicion: 0
}
def mostrar_libros(cola_autores, cola_libros)
    Necesario.limpiar_pantalla
        if cola_libros[:tope] != nil
            aux1 = cola_libros[:tope]
            aux = cola_autores[:tope]
            puts 'Este es el listado de libros:'
            for i in (0 .. cola_autores[:posicion] - 1)
                puts "Autor: #{aux[:valor]}"
                puts "Libros: " 
                for i in (0 .. cola_libros[:size] - 1)
                    if aux[:valor] == aux1[:autor]
                        puts "Nombre del libro: #{aux1[:nombre]}"
                        puts "Autor #{aux1[:autor]}"
                        puts "ISBN #{aux1[:isbn]}"
                        puts "Precio #{aux1[:precio]}"
                        puts "Existencias #{aux1[:existencia]}"
                    end
                    break if aux1[:siguiente] == nil
                    aux1 = aux1[:siguiente]
                end
                #En este paso volvemos a contar los libros y reseteamos el apuntador aux1
                #que va buscando libros con el nombre del autor
                aux1 = cola_libros[:tope]
                break if aux[:siguiente] == nil
                aux = aux[:siguiente]
            end
        else
            puts 'No hay libros para mostrar'
        end
        gets
end
def mostrar_ventas(cola_historial_ventas)
    aux = cola_historial_ventas[:tope]
    for i in (0 .. cola_historial_ventas[:posicion] - 1)
        puts "#{i + 1} de la lista:"
        puts "ISBN: #{aux[:isbn]}"
        puts "Autor: #{aux[:autor]}"
        puts "Nombre: #{aux[:nombre]}"
        puts "Precio: #{aux[:precio]}"
        break if aux[:siguiente] ==  nil
        aux = aux[:siguiente]
    end
end
def regular_ultimas_ventas(cola_historial_ventas, cod_col, isbn, autor, nombre, precio)
    if cola_historial_ventas[:posicion] < cola_historial_ventas[:max]
        Necesario.ingresar_historial(cola_historial_ventas, cod_col, isbn, autor, nombre, precio)
    else
        e = {
            cod: cod_col,
            isbn: isbn,
            autor: autor,
            nombre: nombre,
            precio: precio,
            siguiente: nil
        }
        cola_historial_ventas[:fondo][:siguiente] = e
        cola_historial_ventas[:fondo] = e
        elimino = cola_historial_ventas[:tope]
        cola_historial_ventas[:tope] = elimino[:siguiente]
        elimino[:siguiente] = nil
    end
end
def buscar_venta(cola_historial_ventas, cod)
    aux = cola_historial_ventas[:tope]
    esta = false
    for i in (0 .. cola_historial_ventas[:posicion] - 1)
        if aux[:cod] == cod
            esta = true
            break
        end
        break if aux[:siguiente] == nil
        aux = aux[:siguiente]
    end
    if esta == true
        puts "EL codigo de venta #{aux[:cod]}"
        puts "Compro un libro con las siguientes características:"
        puts "ISBN: #{aux[:isbn]}"
        puts "Autor: #{aux[:autor]}"
        puts "Nombre: #{aux[:nombre]}"
        puts "Precio: #{aux[:precio]}"
    else
        puts 'No esta su codigo de venta ya a de ser retirado del sistema'
    end
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
        Necesario.registrar_libros(cola_libros, n, i, a, pr)
    end
end
def eliminar_libro_existencia(cola_libros, isbn)
    aux = cola_libros[:tope]
    for i in (0 .. cola_libros[:size] - 1)
         break if aux[:isbn] == isbn
         break if aux[:siguiente] == nil
         anterior = aux
         aux = aux[:siguiente]
    end
    #Aqui detecta de cuando compramos si nos acabamos las existencias
    if aux[:existencia] == 0
        #Elimino unico elemento
        if cola_libros[:tope] == aux && cola_libros[:tope][:siguiente] == nil
            cola_libros[:tope] = nil
            cola_libros[:final] = nil
        #Si hay solo dos elementos
        elsif cola_libros[:tope] == aux && cola_libros[:siguiente] == cola_libros[:final]
            elimino = cola_libros[:tope] 
            elimino[:siguiente] = nil
            cola_libros[:tope] = cola_libros[:final]
        #Si elimino el final
        elsif cola_libros[:final] == aux
            anterior[:siguiente] = nil
            cola_libros[:final] = anterior
        #Elimino el tope
        elsif cola_libros[:tope] == aux
            elimino = cola_libros[:tope]
            cola_libros[:tope] = elimino[:siguiente]
            elimino[:siguiente] = nil
        #Si elimino en el centro
        else
            anterior[:siguiente] = aux[:siguiente]
            aux[:siguiente] = nil
        end
    end
end  
def ventas(cola_libros, cola_historial_ventas)
    Necesario.limpiar_pantalla
    puts table([{:value => "Ruby BookStore",:alignment => :center}] , ['Ingrese el isbn del libro'])
    isbn_ventas = gets.chomp.to_i
    aux = cola_libros[:tope]
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
        end
        break if aux[:siguiente] == nil
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
                mostrar_libros(cola_autores, cola_libros)
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
                Necesario.limpiar_pantalla
                if cola_historial_ventas[:tope] != nil
                    puts 'Ingrese el codigo a buscar'
                    x = gets.to_i
                    buscar_venta(cola_historial_ventas, x)
                else
                    puts 'No hay historial de ventas aun'
                end
                gets
            elsif opcion2 == 'C'
                Necesario.limpiar_pantalla
                if cola_historial_ventas[:tope] != nil
                    mostrar_ventas(cola_historial_ventas)
                else
                    puts 'No hay ventas a mostrar'
                end
                gets
            end
            Necesario.limpiar_pantalla
        end while opcion2 != "D"
    end
end while opcion !=3
