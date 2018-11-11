module Necesario
    def self.limpiar_pantalla
        system('clear')
    end
    def self.vacia(cola_libros)
        if cola_libros[:tope] == nil && cola_libros[:final] == nil
            return cola_libros
        end
    end
    def self.ingresar_autores(cola_autores, nombre)
        autores = {
            valor: nombre,
            siguiente: nil,
        }
        if cola_autores[:tope] == nil && cola_autores[:fondo] == nil
            cola_autores[:tope] = autores
            cola_autores[:fondo] = autores
        elsif
            elemento_final = cola_autores[:fondo]
            elemento_final[:siguiente] = autores
            cola_autores[:fondo] = autores
        end
        cola_autores[:posicion] += 1
    end
    def self.validar_autores(cola_autores, num, cola_libros)
        limpiar_pantalla
        if num == 1
            puts table(['Ingrese el nombre del libro'])
            nam = gets.chomp
            puts table(['Ingrese el isbn del libro'])
            is = gets.chomp.to_i
            puts table(['Ingrese el nombre del autor'])
            aut = gets.chomp.upcase
            puts table(['Ingrese el precio del libro'])
            pri = gets.to_i
            name = aut
        else
            puts table(['Ingrese el nombre del autor'])
            name = gets.chomp.upcase
        end
        esta = false
        aux = cola_autores[:tope]
        for i in (0 .. cola_autores[:posicion] - 1)
            if name == aux[:valor]
                esta = true
            else
                break if aux[:siguiente] == nil
                aux = aux[:siguiente]
            end
        end
        if esta == true
            if num == 0
              puts table([{:value => "Ruby BookStore",:alignment => :center}] , ['Ya está en autores, no será agregado'])
            else
                registrar_libros(cola_libros, nam, is, aut, pri)
            end
        else
            if cola_autores[:posicion] < cola_autores[:max]
                if num == 0
                    ingresar_autores(cola_autores, name)
                    puts table([{:value => "Ruby BookStore",:alignment => :center}] , ['No está el autor pero sera agregado'])
                else
                    ingresar_autores(cola_autores, name)
                end
            else
                puts table([{:value => "Ruby BookStore",:alignment => :center}] , ['Ya ha llegado al tope de autores'])
                condicional = false
            end
            if condicional != false && num == 1
                registrar_libros(cola_libros, nam, is, aut, pri)
            end
        end
        gets
    end
    def self.mostrar_autores(cola_autores, cola_libros)
        limpiar_pantalla
        if cola_autores[:tope] != nil && cola_autores[:fondo] != nil
            aux1 = cola_libros[:tope]
            aux = cola_autores[:tope]
            puts 'Este es el listado de autores'
            #Cont es la cantidad de libros que tiene ese autor
            cont = 0
            for i in (0 .. cola_autores[:posicion] - 1)
                print 'autor: '
                print "#{aux[:valor]}, "
                for i in (0 .. cola_libros[:size] - 1)
                    if aux[:valor] == aux1[:autor]
                        cont += 1
                    end
                    break if aux1[:siguiente] == nil
                    aux1 = aux1[:siguiente]
                end
                #En este paso volvemos a contar los libros y reseteamos el apuntador aux1
                #que va buscando libros con el nombre del autor
                aux1 = cola_libros[:tope]
                print "#{cont}\n"
                cont = 0
                break if aux[:siguiente] == nil
                aux = aux[:siguiente]
            end
        else
            puts table([{:value => "Ruby BookStore",:alignment => :center}] , ['No hay autores para mostrar'])
        end
        gets
    end
    def self.buscar_isbn(cola_libros)
        limpiar_pantalla
        if vacia(cola_libros)
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
    def self.ingresar_historial(cola_historial_ventas, cod, isbn, autor, nombre, precio)
        element = {
            cod: cod,
            isbn: isbn,
            autor: autor,
            nombre: nombre,
            precio: precio,
            siguiente: nil
        }
        if cola_historial_ventas[:tope] == nil && cola_historial_ventas[:fondo] == nil
            cola_historial_ventas[:tope] = element
            cola_historial_ventas[:fondo] = element
        else
            cola_historial_ventas[:fondo][:siguiente] = element
            cola_historial_ventas[:fondo] = element
        end
    end
    def self.buscar_autor(cola_libros, cola_autores)
        limpiar_pantalla
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
        if esta == false
            puts table([{:value => "Ruby BookStore",:alignment => :center}] , ['Su autor no se encuentra en la base de datos'])
        end
        gets
    end
end