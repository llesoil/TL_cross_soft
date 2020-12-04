#!/bin/sh

numb='2419'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 4.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 30 --keyint 280 --lookahead-threads 0 --min-keyint 28 --qp 10 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset veryslow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.5,1.2,4.8,0.5,0.7,0.3,1,0,4,30,280,0,28,10,5,2,67,18,5,1000,-2:-2,dia,show,veryslow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"