#!/bin/sh

numb='1175'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 15 --keyint 220 --lookahead-threads 3 --min-keyint 30 --qp 20 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset superfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,1.5,1.3,1.0,1.4,0.4,0.8,0.2,2,0,8,15,220,3,30,20,3,2,60,28,6,2000,-1:-1,hex,show,superfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"