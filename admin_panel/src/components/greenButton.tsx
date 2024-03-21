

export default function GreenButton({text, onClick, href}: {text: string, onClick?: Function, href?: string}) {



    return (<div className="bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4 rounded">
        {href ? 
        <a className="" href={`/fioretti-app-admin/${href}`} >{text}</a>
        :
        <button className="" onClick={() => {if (onClick) onClick();}}>{text}</button>}
    </div>
        
        )
}