#!/bin/sh

numb='992'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 4.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 0 --keyint 250 --lookahead-threads 4 --min-keyint 21 --qp 50 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset ultrafast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.1,1.1,4.6,0.3,0.6,0.6,2,0,8,0,250,4,21,50,5,2,67,48,5,2000,-2:-2,hex,show,ultrafast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"