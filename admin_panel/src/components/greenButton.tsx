

export default function GreenButton({text, onClick, href}: {text: string, onClick?: Function, href?: string}) {



    return (href ? 
        <a className="bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4 rounded" href={href} >{text}</a>
        :
        <button className="bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4 rounded" onClick={() => {if (onClick) onClick();}}>{text}</button>
        )
}