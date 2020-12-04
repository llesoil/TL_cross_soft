#!/bin/sh

numb='345'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 2.2 --qblur 0.2 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 10 --crf 50 --keyint 250 --lookahead-threads 0 --min-keyint 26 --qp 0 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset placebo --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.5,1.4,1.2,2.2,0.2,0.7,0.1,2,0,10,50,250,0,26,0,4,3,65,38,2,2000,-2:-2,umh,show,placebo,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"