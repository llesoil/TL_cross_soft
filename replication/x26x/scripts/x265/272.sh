#!/bin/sh

numb='273'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 2.2 --qblur 0.2 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 5 --keyint 200 --lookahead-threads 1 --min-keyint 20 --qp 0 --qpstep 3 --qpmin 1 --qpmax 69 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.5,1.2,2.2,0.2,0.7,0.6,3,0,0,5,200,1,20,0,3,1,69,28,5,2000,1:1,umh,show,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"