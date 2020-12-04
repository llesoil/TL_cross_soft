#!/bin/sh

numb='431'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 3.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 15 --keyint 260 --lookahead-threads 3 --min-keyint 20 --qp 40 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset slower --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.4,1.1,3.4,0.3,0.8,0.6,0,0,4,15,260,3,20,40,4,3,65,38,5,1000,-2:-2,umh,crop,slower,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"