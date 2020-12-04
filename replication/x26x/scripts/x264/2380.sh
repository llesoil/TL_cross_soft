#!/bin/sh

numb='2381'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 30 --keyint 220 --lookahead-threads 3 --min-keyint 23 --qp 50 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset ultrafast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.5,1.0,1.0,1.2,0.2,0.6,0.7,1,0,16,30,220,3,23,50,4,1,68,28,2,1000,-1:-1,umh,show,ultrafast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"