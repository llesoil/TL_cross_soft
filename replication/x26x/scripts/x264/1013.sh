#!/bin/sh

numb='1014'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 0.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.7 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 15 --keyint 290 --lookahead-threads 3 --min-keyint 23 --qp 50 --qpstep 5 --qpmin 0 --qpmax 60 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset veryslow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.1,1.4,0.4,0.3,0.6,0.7,1,1,10,15,290,3,23,50,5,0,60,38,3,1000,-2:-2,umh,show,veryslow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"