#!/bin/sh

numb='1847'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 0.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.9 --aq-mode 0 --b-adapt 0 --bframes 0 --crf 10 --keyint 270 --lookahead-threads 3 --min-keyint 25 --qp 0 --qpstep 4 --qpmin 0 --qpmax 63 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset veryfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,2.0,1.3,1.2,0.6,0.5,0.8,0.9,0,0,0,10,270,3,25,0,4,0,63,18,5,1000,-2:-2,umh,show,veryfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"