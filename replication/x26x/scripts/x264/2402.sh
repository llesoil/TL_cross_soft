#!/bin/sh

numb='2403'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 50 --keyint 200 --lookahead-threads 3 --min-keyint 23 --qp 40 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset ultrafast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.0,1.6,1.2,1.8,0.3,0.6,0.4,2,2,16,50,200,3,23,40,3,2,62,38,3,1000,-1:-1,hex,show,ultrafast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"