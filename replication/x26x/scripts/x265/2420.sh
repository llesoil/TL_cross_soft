#!/bin/sh

numb='2421'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --intra-refresh --no-asm --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 4.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 50 --keyint 300 --lookahead-threads 4 --min-keyint 30 --qp 20 --qpstep 5 --qpmin 0 --qpmax 61 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset ultrafast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,--no-asm,None,--weightb,2.5,1.5,1.3,4.2,0.3,0.6,0.5,0,2,4,50,300,4,30,20,5,0,61,38,1,2000,-1:-1,hex,show,ultrafast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"