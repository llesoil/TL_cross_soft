#!/bin/sh

numb='2907'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 1.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 50 --keyint 280 --lookahead-threads 0 --min-keyint 21 --qp 50 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,1.0,1.2,1.0,1.2,0.6,0.8,0.6,2,0,0,50,280,0,21,50,5,0,62,48,2,1000,-2:-2,dia,show,medium,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"