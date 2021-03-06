#!/bin/sh

numb='1393'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 4.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 0 --crf 50 --keyint 230 --lookahead-threads 3 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.1,1.3,4.6,0.4,0.8,0.5,0,2,0,50,230,3,26,20,4,0,62,28,5,2000,-2:-2,umh,show,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"