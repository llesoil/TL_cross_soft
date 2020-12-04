#!/bin/sh

numb='408'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 3.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 45 --keyint 280 --lookahead-threads 2 --min-keyint 30 --qp 40 --qpstep 4 --qpmin 4 --qpmax 64 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset ultrafast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,0.5,1.5,1.4,3.6,0.4,0.9,0.8,2,0,6,45,280,2,30,40,4,4,64,28,2,1000,-2:-2,hex,crop,ultrafast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"