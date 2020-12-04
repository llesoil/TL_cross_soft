#!/bin/sh

numb='836'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 3.2 --qblur 0.4 --qcomp 0.8 --vbv-init 0.7 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 50 --keyint 230 --lookahead-threads 3 --min-keyint 28 --qp 40 --qpstep 4 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.5,1.3,1.1,3.2,0.4,0.8,0.7,0,2,0,50,230,3,28,40,4,4,61,28,1,1000,-1:-1,umh,show,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"