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
end