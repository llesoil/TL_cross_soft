#!/bin/sh

numb='1248'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 0.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 10 --keyint 290 --lookahead-threads 0 --min-keyint 29 --qp 50 --qpstep 3 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.0,1.2,0.8,0.6,0.6,0.4,0,2,16,10,290,0,29,50,3,3,69,18,3,1000,-1:-1,dia,show,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"