#!/bin/sh

numb='2002'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 2.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 20 --keyint 220 --lookahead-threads 1 --min-keyint 25 --qp 10 --qpstep 3 --qpmin 0 --qpmax 68 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.0,1.0,2.8,0.3,0.8,0.3,2,2,2,20,220,1,25,10,3,0,68,18,6,1000,-2:-2,dia,show,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"