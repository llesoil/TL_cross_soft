#!/bin/sh

numb='815'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.9 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 30 --keyint 300 --lookahead-threads 3 --min-keyint 20 --qp 30 --qpstep 5 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.0,1.0,1.2,0.2,0.8,0.9,1,2,0,30,300,3,20,30,5,4,60,38,6,1000,-2:-2,umh,crop,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"