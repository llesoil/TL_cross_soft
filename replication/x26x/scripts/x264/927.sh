#!/bin/sh

numb='928'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 2.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.8 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 15 --keyint 250 --lookahead-threads 4 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 4 --qpmax 65 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset fast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,2.0,1.2,1.2,2.2,0.6,0.8,0.8,0,2,16,15,250,4,25,20,3,4,65,28,6,2000,-2:-2,umh,show,fast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"