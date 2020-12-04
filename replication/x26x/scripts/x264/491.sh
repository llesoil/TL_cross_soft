#!/bin/sh

numb='492'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 1.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.5 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 10 --keyint 280 --lookahead-threads 4 --min-keyint 25 --qp 40 --qpstep 3 --qpmin 1 --qpmax 62 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset veryslow --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.1,1.0,1.6,0.6,0.6,0.5,2,0,14,10,280,4,25,40,3,1,62,18,2,2000,-1:-1,hex,show,veryslow,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"