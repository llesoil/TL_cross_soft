#!/bin/sh

numb='475'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 2.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 0 --keyint 280 --lookahead-threads 3 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 1 --qpmax 65 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset superfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.3,1.3,2.0,0.3,0.7,0.5,0,0,2,0,280,3,30,40,3,1,65,48,5,1000,-1:-1,umh,show,superfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"