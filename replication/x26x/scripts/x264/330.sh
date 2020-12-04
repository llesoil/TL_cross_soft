#!/bin/sh

numb='331'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --intra-refresh --no-asm --weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 1.0 --qblur 0.2 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 20 --keyint 210 --lookahead-threads 4 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 0 --qpmax 62 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,--intra-refresh,--no-asm,None,--weightb,2.0,1.3,1.3,1.0,0.2,0.7,0.6,3,2,14,20,210,4,28,40,5,0,62,28,1,2000,-1:-1,umh,show,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"