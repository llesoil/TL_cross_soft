#!/bin/sh

numb='2662'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 0.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 10 --keyint 250 --lookahead-threads 0 --min-keyint 29 --qp 20 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,0.5,1.6,1.2,0.8,0.5,0.9,0.7,1,2,16,10,250,0,29,20,4,2,67,18,3,1000,-2:-2,umh,show,slower,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"